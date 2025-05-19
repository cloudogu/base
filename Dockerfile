ARG ALPINE_VER="3.21.0"
ARG ALPINE_VER_SHA="beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d"

FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA}

LABEL maintainer="hello@cloudogu.com"

COPY resources/ /

COPY packages/doguctl.tar.gz /tmp/doguctl.tar.gz
RUN tar -xzf /tmp/doguctl.tar.gz -C /tmp \
    && install -m 755 -p /tmp/doguctl /usr/local/bin/doguctl \
    && rm -f /tmp/doguctl.tar.gz /tmp/doguctl

# install dependencies
RUN apk update \
    && apk add --no-cache \
        bash \
        ca-certificates \
        jq \
        openssl \
        tar \
        zip unzip \
    && apk upgrade
