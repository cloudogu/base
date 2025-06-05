# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534

ARG ALPINE_VER=3.21.0
ARG ALPINE_VER_SHA=beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d
ARG DOGUCTL_VERSION=0.13.2
ARG DOGUCTL_SHA256SUM=94a652beba7484ba92f3e869e11be82902769490ef5272e6eac1a3d0969f1a0f

FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA} AS doguctl-provider

ARG DOGUCTL_VERSION
ARG DOGUCTL_SHA256SUM

COPY packages/doguctl-${DOGUCTL_VERSION}.tar.gz /doguctl.tar.gz

RUN \
  echo "$DOGUCTL_SHA256SUM /doguctl.tar.gz" | sha256sum -c - && \
  tar -xzf /doguctl.tar.gz && \
  rm /doguctl.tar.gz

FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA}

LABEL maintainer="hello@cloudogu.com"

COPY resources/ /

# copy doguctl binary
COPY --from=doguctl-provider /doguctl /usr/bin/

# install dependencies
RUN apk update && apk upgrade
RUN apk add --no-cache bash openssl tar zip unzip ca-certificates jq
