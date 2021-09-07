# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534
ARG doguctl_version=0.7.0

FROM alpine:3.14.2 as doguctlBinaryVerifier
ARG doguctl_version

ENV DOGUCTL_SHA256=4c38d308c2fe3f8eb2b44c075af7038c2d0dc1c4a5dfcd5d75393de2d1f06c0c
ENV DOGUCTL_VERSION=$doguctl_version
RUN mkdir packages
COPY packages/doguctl-$DOGUCTL_VERSION.tar.gz /packages
RUN sha256sum "/packages/doguctl-${DOGUCTL_VERSION}.tar.gz"
RUN set +x && echo "4c38d308c2fe3f8eb2b44c075af7038c2d0dc1c4a5dfcd5d75393de2d1f06c0c */packages/doguctl-${DOGUCTL_VERSION}.tar.gz" | sha256sum -c


FROM alpine:3.14.2
ARG doguctl_version
LABEL maintainer="hello@cloudogu.com"

ENV DOGUCTL_VERSION=${doguctl_version}

COPY resources/ /

# unpack and install doguctl
ADD packages/doguctl-${DOGUCTL_VERSION}.tar.gz /usr/bin/

# install dependencies
RUN apk update && apk upgrade
RUN apk add --no-cache bash curl openssl wget tar zip unzip ca-certificates jq
