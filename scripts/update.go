package main

import (
	"bytes"
	"cmp"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"maps"
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
		Short: "Pin the published node image digest per variant and the version and pnpm major per line from the node repository",
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
		version, digests, pnpm := before.versions[line], configuration{}, before.pnpm[line]
		for _, variant := range variants {
			digests[line+"-"+variant.name] = before.digests[line+"-"+variant.name]
		}

		if candidate := upstream["versions.json"][line]; candidate != "" {
			resolved, err := fetchVariantDigests(ctx, line, candidate, version, before.digests)
			if err != nil {
				return err
			}

			if resolved != nil {
				version, digests, pnpm = candidate, resolved, cmp.Or(upstream["pnpm.json"][line], pnpm)
			}
		}

		if version == "" || pnpm == "" || slices.Contains(slices.Collect(maps.Values(digests)), "") {
			return fmt.Errorf("no published node image found for line %s", line)
		}

		after.versions[line], after.pnpm[line] = version, pnpm
		maps.Copy(after.digests, digests)
	}

	for alias, line := range upstream["aliases.json"] {
		if slices.Contains(lines, line) {
			after.aliases[alias] = line
		}
	}

	for image, pinned := range before.builders {
		name, tag, _ := strings.Cut(image, ":")

		digest, err := fetchDigest(ctx, library+name, tag, pinned)
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

// fetchVariantDigests resolves a release's image digest for every variant, or nil while one is unpublished.
func fetchVariantDigests(ctx context.Context, line, candidate, version string, digests configuration) (configuration, error) {
	resolved := configuration{}
	for _, variant := range variants {
		key, pinned := line+"-"+variant.name, ""
		if candidate == version {
			pinned = digests[key]
		}

		digest, err := fetchDigest(ctx, repository, candidate+"-"+variant.upstream, pinned)
		if err != nil || digest == "" {
			return nil, err
		}

		resolved[key] = digest
	}

	return resolved, nil
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
