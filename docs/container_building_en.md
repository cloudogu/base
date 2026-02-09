# Container building

This container image provides the base of many dogu container images.
Among other parts the helper binary `doguctl` is a vital part of this image.

## Instructions for building and deploying

On a development branch:

1. Update the `Makefile` fields `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER`, `DOGUCTL_VERSION` and `DOGUCTL_VER_SHA` accordingly
2. Create a section for the new version in the `CHANGELOG.md`.
3. PR/merge the development branch into the target-branch
4. Tag the target commit (e.g. `v3.45.6-7`) for the release.

The following parameters are available in the Jenkins Pipeline:
- `PublishRelease`
- `PublishPrerelease`

If these parameters are enabled, the image will be published after successful build.

With the `PublishPrerelease` parameter enabled, the image will be published in the namespace `registry.cloudogu.com/prerelease_official/`.

With the `PublishRelease` parameter enabled, the image will be published in the namespace `registry.cloudogu.com/official/` and a GitHub Release will be created.

To rebuild and publish older versions of the image, branches are available for which the build and release process can be started using parameters similar to the main branch.

## Instructions for building locally

1. Update the `Makefile` fields `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` and `DOGUCTL_VERSION` accordingly
2. Switch to an environment where a download of the `doguctl` binary is possible (you'll need private repo permissions)
   1. Download the most recent version of `doguctl` from [the doguctl release page](https://github.com/cloudogu/doguctl/releases)
   2. Place the binary in `packages/`
3. Run `make build`
