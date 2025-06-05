# Container building

This container image provides the base of many dogu container images.
Among other parts the helper binary `doguctl` is a vital part of this image.

## Instructions for building and deploying

On a development branch:

1. Update the `Makefile` fields `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` and `DOGUCTL_VERSION` accordingly
2. PR/merge the development branch into the main branch

## Instructions for building locally

1. Update the `Makefile` fields `ALPINE_VERSION`, `ALPINE_VER_SHA`, `CHANGE_COUNTER` and `DOGUCTL_VERSION` accordingly
2. Switch to an environment where a download of the `doguctl` binary is possible (you'll need private repo permissions)
   1. Download the most recent version of `doguctl` from [the doguctl release page](https://github.com/cloudogu/doguctl/releases)
   2. Place the binary in `packages/`
3. Run `make build`
