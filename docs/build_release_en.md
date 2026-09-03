# Build & Release

Apply your changes, e.g.:

1. In `Makefile`, update the `*_VERSION` and `CHANGE_COUNTER` fields.
2. Create a section for the new version in the `CHANGELOG.md`.

### Build Locally

1. Download the [`doguctl`](https://github.com/cloudogu/doguctl/releases) release matching `DOGUCTL_VERSION`.
2. Save it as `packages/doguctl.tar.gz`.
3. Build with `make build`.
4. Test with `make unit-test-shell-local`.

### Publish Release

PR/merge the development changeset into the respective main branch (`alpine3.23`, `alpine3.24`, ...).

Use Pipeline parameter `PublishPrerelease` to publish a prerelease image to namespace `registry.cloudogu.com/prerelease_official/`.

Use Pipeline parameter `PublishRelease` to publish an image to namespace `registry.cloudogu.com/official/` and create a GitHub release.
The release tag will be generated automatically from the `Makefile` variables.
