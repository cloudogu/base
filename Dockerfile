# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534
ARG doguctl_version=0.7.0

ARG ALPINE_VER=3.18.3
ARG ALPINE_VER_SHA=c5c5fda71656f28e49ac9c5416b3643eaa6a108a8093151d6d1afc9463be8e33

FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA} as doguctlBinaryVerifier
ARG doguctl_version

ENV DOGUCTL_SHA256=4c38d308c2fe3f8eb2b44c075af7038c2d0dc1c4a5dfcd5d75393de2d1f06c0c
ENV DOGUCTL_VERSION=$doguctl_version
RUN mkdir packages
COPY packages/doguctl-$DOGUCTL_VERSION.tar.gz /packages
RUN sha256sum "/packages/doguctl-${DOGUCTL_VERSION}.tar.gz"
RUN set +x && echo "4c38d308c2fe3f8eb2b44c075af7038c2d0dc1c4a5dfcd5d75393de2d1f06c0c */packages/doguctl-${DOGUCTL_VERSION}.tar.gz" | sha256sum -c


FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA}
ARG doguctl_version
LABEL maintainer="hello@cloudogu.com"

ENV DOGUCTL_VERSION=${doguctl_version}

COPY resources/ /

# unpack and install doguctl
ADD packages/doguctl-${DOGUCTL_VERSION}.tar.gz /usr/bin/

# install dependencies
RUN apk update && apk upgrade
RUN apk add --no-cache bash openssl tar zip unzip ca-certificates jq
