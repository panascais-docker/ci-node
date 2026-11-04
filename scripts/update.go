package main

import (
	"bytes"
	"cmp"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"path/filepath"
	"slices"
	"strings"
	"time"

	"github.com/google/go-containerregistry/pkg/crane"
	v1 "github.com/google/go-containerregistry/pkg/v1"
	"github.com/spf13/cobra"
)

const nodeConfiguration = "https://raw.githubusercontent.com/panascais-docker/node/master/configuration"

var architectures = []string{"amd64", "arm64"}

func updateCommand() *cobra.Command {
	var node string

	command := &cobra.Command{
		Use:   "update",
		Short: "Pin the published node image digest, version and pnpm major per line from the node repository",
		Args:  cobra.NoArgs,
		RunE:  func(command *cobra.Command, _ []string) error { return update(command.Context(), node) },
	}
	command.Flags().StringVar(&node, "node", nodeConfiguration, "URL or local directory of the node repository configuration")

	return command
}

func update(ctx context.Context, node string) error {
	ctx, cancel := context.WithTimeout(ctx, 5*time.Minute)
	defer cancel()

	lines, err := readLines()
	if err != nil {
		return err
	}

	before, err := readPins()
	if err != nil {
		return err
	}

	upstream := map[string]configuration{}
	for _, file := range []string{"aliases.json", "pnpm.json", "versions.json"} {
		if upstream[file], err = readUpstream(ctx, node, file); err != nil {
			return err
		}
	}

	after := pins{aliases: configuration{}, builders: configuration{}, digests: configuration{}, pnpm: configuration{}, versions: configuration{}}
	for _, line := range lines {
		version, digest, pnpm := before.versions[line], before.digests[line], before.pnpm[line]
		if candidate := upstream["versions.json"][line]; candidate != "" {
			pinned := ""
			if candidate == version {
				pinned = digest
			}

			resolved, err := fetchDigest(ctx, repository, candidate, pinned)
			if err != nil {
				return err
			}

			if resolved != "" {
				version, digest, pnpm = candidate, resolved, cmp.Or(upstream["pnpm.json"][line], pnpm)
			}
		}

		if version == "" || digest == "" || pnpm == "" {
			return fmt.Errorf("no published node image found for line %s", line)
		}

		after.versions[line], after.digests[line], after.pnpm[line] = version, digest, pnpm
	}

	for alias, line := range upstream["aliases.json"] {
		if slices.Contains(lines, line) {
			after.aliases[alias] = line
		}
	}

	for image, pinned := range before.builders {
		name, tag, _ := strings.Cut(image, ":")

		digest, err := fetchDigest(ctx, mirror+name, tag, pinned)
		if err != nil {
			return err
		}

		after.builders[image] = cmp.Or(digest, pinned)
	}

	return writePins(before, after)
}

func readUpstream(ctx context.Context, node, file string) (configuration, error) {
	if !strings.HasPrefix(node, "https://") {
		return readConfiguration(filepath.Join(node, file))
	}

	request, err := http.NewRequestWithContext(ctx, http.MethodGet, node+"/"+file, nil)
	if err != nil {
		return nil, err
	}

	response, err := http.DefaultClient.Do(request)
	if err != nil {
		return nil, err
	}
	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("fetching %s: %s", request.URL, response.Status)
	}

	content, err := io.ReadAll(response.Body)
	if err != nil {
		return nil, err
	}

	var value configuration
	if err := json.Unmarshal(content, &value); err != nil {
		return nil, fmt.Errorf("parsing %s: %w", request.URL, err)
	}

	return value, nil
}

func fetchDigest(ctx context.Context, image, tag, pinned string) (string, error) {
	head, err := crane.Head(image+":"+tag, crane.WithContext(ctx))
	if missing(err) {
		return "", nil
	}

	if err != nil || head.Digest.String() == pinned {
		return pinned, err
	}

	manifest, err := crane.Manifest(image+"@"+head.Digest.String(), crane.WithContext(ctx))
	if err != nil {
		return "", err
	}

	index, err := v1.ParseIndexManifest(bytes.NewReader(manifest))
	if err != nil {
		return "", err
	}

	for _, architecture := range architectures {
		if !slices.ContainsFunc(index.Manifests, func(entry v1.Descriptor) bool {
			return entry.Platform != nil && entry.Platform.Architecture == architecture
		}) {
			return "", nil
		}
	}

	return head.Digest.String(), nil
}
