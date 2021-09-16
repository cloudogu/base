# Container building

This container image provides the base of many dogu container images. Among other parts the helper binary `doguctl` is a vital part of this image. 

## Instructions for building and deploying

1. Switch to a environment where a download of the `doguctl` binary is possible (you'll need private repo permissions)
   1. Download the most recent version of `doguctl` from [the doguctl release page](https://github.com/cloudogu/doguctl/releases)
   1. Place the binary in `packages/`
   1. Update the `doguctl` SHA256 checksum if the version has changed
2. Switch to a running CES instance
   1. Update the `Makefile` fields `ALPINE_VERSION` and `CHANGE_COUNTER` accordingly
   2. Build the base dogu image with `make` or `make build`
   3. Deploy the base dogu image with `make deploy`
