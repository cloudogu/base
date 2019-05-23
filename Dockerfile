FROM alpine:3.9.4
LABEL maintainer="sebastian.sdorra@cloudogu.com"

ENV DOGUCTL_VERSION 0.4.0

# copy resource
COPY resources/ /

# install doguctl
ADD packages/doguctl-${DOGUCTL_VERSION}.tar.gz /usr/bin/

# install dependencies
RUN apk add --no-cache bash curl openssl wget tar zip unzip ca-certificates jq
