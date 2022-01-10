FROM alpine:3.12.4
LABEL maintainer="hello@cloudogu.com"

ENV DOGUCTL_VERSION 0.7.0

# copy resource
COPY resources/ /

# install doguctl
ADD packages/doguctl-${DOGUCTL_VERSION}.tar.gz /usr/bin/

# install dependencies
RUN apk update && apk upgrade
RUN apk add --no-cache bash curl openssl wget tar zip unzip ca-certificates jq
