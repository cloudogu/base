# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534
ARG doguctl_version=0.13.1

FROM alpine:3.17.10 AS doguctlbinaryverifier
ARG doguctl_version

ENV DOGUCTL_SHA256=f82f17c6aa64f8d7ac1cc922043823660eb595a2ad45a42b47d10cf86696a85b
ENV DOGUCTL_VERSION=$doguctl_version
RUN mkdir packages
COPY packages/doguctl-$DOGUCTL_VERSION.tar.gz /packages
RUN sha256sum "/packages/doguctl-${DOGUCTL_VERSION}.tar.gz"
RUN set +x && echo "4c38d308c2fe3f8eb2b44c075af7038c2d0dc1c4a5dfcd5d75393de2d1f06c0c */packages/doguctl-${DOGUCTL_VERSION}.tar.gz" | sha256sum -c


FROM alpine:3.17.10
ARG doguctl_version
LABEL maintainer="hello@cloudogu.com"

ENV DOGUCTL_VERSION=${doguctl_version}

COPY resources/ /

# unpack and install doguctl
ADD packages/doguctl-${DOGUCTL_VERSION}.tar.gz /usr/bin/

# install dependencies
RUN apk update && apk upgrade
RUN apk add --no-cache bash openssl tar zip unzip ca-certificates jq
