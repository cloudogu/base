ALPINE_VERSION=3.23.6
ALPINE_VER_SHA=85fe1e81d6758c208f3e1eed4338a1997e19d4be002d4dd32d3100c9a8c010a0
CHANGE_COUNTER=1
IMAGE_TAG=$(ALPINE_VERSION)-$(CHANGE_COUNTER)
IMAGE_NAME=registry.cloudogu.com/official/base
IMAGE_NAME_PRERELEASE=registry.cloudogu.com/prerelease_official/base
DOGUCTL_VERSION=0.17.0
DOGUCTL_VER_SHA=f9e9a860fc5bcc808a6f11320026a4012b655846715144f08c015ec36e767d5d
# renovate: datasource=github-tags depName=cloudogu/makefiles extractVersion=^v(?<version>.*)$
MAKEFILES_VERSION=11.1.2

default: build

include build/make/variables.mk
include build/make/self-update.mk
include build/make/clean.mk
include build/make/bats.mk

TESTS_DIR=./unitTests

.PHONY: info
info:
	@echo "version information ..."
	@echo "Image (release)   : $(IMAGE_NAME):$(IMAGE_TAG)"
	@echo "Image (prerelease): $(IMAGE_NAME_PRERELEASE):$(IMAGE_TAG)"

.PHONY: build
build:
	docker build \
	--no-cache \
	--build-arg "ALPINE_VERSION=$(ALPINE_VERSION)" \
	--build-arg "ALPINE_VER_SHA=$(ALPINE_VER_SHA)" \
	-t "$(IMAGE_NAME):$(IMAGE_TAG)" .

.PHONY: deploy
deploy: build
	@echo "Publishing image $(IMAGE_NAME):$(IMAGE_TAG)"
	docker push "$(IMAGE_NAME):$(IMAGE_TAG)"

.PHONY: deploy-prerelease
deploy-prerelease: build
	@echo "Publishing image $(IMAGE_NAME_PRERELEASE):$(IMAGE_TAG)"
	docker tag "$(IMAGE_NAME):$(IMAGE_TAG)" "$(IMAGE_NAME_PRERELEASE):$(IMAGE_TAG)"
	docker rmi "$(IMAGE_NAME):$(IMAGE_TAG)"
	docker push "$(IMAGE_NAME_PRERELEASE):$(IMAGE_TAG)"

.PHONY: shell
shell: build
	docker run --rm -ti "$(IMAGE_NAME):$(IMAGE_TAG)" bash || 0
