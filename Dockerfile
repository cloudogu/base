# keep variables beyond the single build stages, see https://stackoverflow.com/a/53682110/12529534
ARG doguctl_version=0.12.2

ARG ALPINE_VER=3.20.3
ARG ALPINE_VER_SHA=33735bd63cf84d7e388d9f6d297d348c523c044410f553bd878c6d7829612735

FROM alpine:${ALPINE_VER}@sha256:${ALPINE_VER_SHA} AS doguctl_binary_verifier
ARG doguctl_version

ENV DOGUCTL_SHA256=ac4b56f17a8b86ae398b45f33ba0c11bf4e2b80030d915d5b89207582f3ff648
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
