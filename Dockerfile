# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534
ARG doguctl_version=0.7.0

FROM alpine:3.14.0 as doguctlBinaryVerifier
ARG doguctl_version

ENV DOGUCTL_SHA256=4c38d308c2fe3f8eb2b44c075af7038c2d0dc1c4a5dfcd5d75393de2d1f06c0c
ENV DOGUCTL_VERSION=$doguctl_version
RUN mkdir packages
COPY packages/doguctl-$DOGUCTL_VERSION.tar.gz /packages
RUN sha256sum "/packages/doguctl-${DOGUCTL_VERSION}.tar.gz"
RUN set +x && echo "4c38d308c2fe3f8eb2b44c075af7038c2d0dc1c4a5dfcd5d75393de2d1f06c0c */packages/doguctl-${DOGUCTL_VERSION}.tar.gz" | sha256sum -c


FROM alpine:3.14.0
ARG doguctl_version
LABEL maintainer="hello@cloudogu.com"

ENV DOGUCTL_VERSION=${doguctl_version}

COPY resources/ /

# unpack and install doguctl
ADD packages/doguctl-${DOGUCTL_VERSION}.tar.gz /usr/bin/

# install dependencies
RUN apk update && apk upgrade
RUN apk add --allow-untrusted /musl-1.1.24-r10.apk /ncurses-terminfo-base-6.2_p20200523-r1.apk /ncurses-libs-6.2_p20200523-r1.apk /readline-8.0.4-r0.apk /zlib-1.2.11-r3.apk /libssl1.1-1.1.1l-r0.apk /libcrypto1.1-1.1.1l-r0.apk /apk-tools-2.10.8-r0.apk /bash-5.0.17-r0.apk
RUN apk add --no-cache curl openssl wget tar zip unzip ca-certificates jq
