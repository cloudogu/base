# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534
ARG doguctl_version=0.12.1

ARG ALPINE_VER=3.15.11
ARG ALPINE_VER_SHA=19b4bcc4f60e99dd5ebdca0cbce22c503bbcff197549d7e19dab4f22254dc864

FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA} as doguctlBinaryVerifier
ARG doguctl_version

ENV DOGUCTL_SHA256=5f4d596d9d5efe9691043a9763c7eb8f3a4fd054029a6ff3a219410187fdbd5e
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
