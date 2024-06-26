# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534
ARG doguctl_version=0.12.0

ARG ALPINE_VER=3.18.7
ARG ALPINE_VER_SHA=1875c923b73448b558132e7d4a44b815d078779ed7a73f76209c6372de95ea8d

FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA} as doguctlBinaryVerifier
ARG doguctl_version

ENV DOGUCTL_SHA256=3101d6a96916f10fd449bd57b7307415e9af94921e08dcfba299ae379f81b64c
ENV DOGUCTL_VERSION=$doguctl_version
RUN mkdir packages
COPY packages/doguctl-$DOGUCTL_VERSION.tar.gz /packages
RUN sha256sum "/packages/doguctl-${DOGUCTL_VERSION}.tar.gz"
RUN set +x && echo "${DOGUCTL_SHA256} */packages/doguctl-${DOGUCTL_VERSION}.tar.gz" | sha256sum -c


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
