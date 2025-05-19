# Container building

This container image provides the base of many dogu container images.
Among other parts the helper binary `doguctl` is a vital part of this image.

## Instructions for building and deploying

On a development branch:

1. Update the `Dockerfile` fields `ALPINE_VER` and `ALPINE_VER_SHA` accordingly
2. Update the `Makefile` field `CHANGE_COUNTER` accordingly
3. Update the `Makefile` field `DOGUCTL_VERSION` accordingly

PR/merge the development branch into the main branch.

## Instructions for building locally

1. Update the `Dockerfile` fields `ALPINE_VER` and `ALPINE_VER_SHA` accordingly
2. Update the `Makefile` field `CHANGE_COUNTER` accordingly
3. Update the `Makefile` field `DOGUCTL_VERSION` accordingly
4. Switch to an environment where a download of the `doguctl` binary is possible (you'll need private repo permissions)
   1. Download the most recent version of `doguctl` from [the doguctl release page](https://github.com/cloudogu/doguctl/releases)
   2. Place the binary in `packages/`
5. Run `make build`
