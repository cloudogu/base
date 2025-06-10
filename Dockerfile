# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534

ARG ALPINE_VER=3.22.0
ARG ALPINE_VER_SHA=8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715
ARG DOGUCTL_VERSION=0.13.3
ARG DOGUCTL_SHA256SUM=612ca0c4890984401206c148106e4ced23c90924dd2ad979b2cbcc8b0a50e395

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
