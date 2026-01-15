ALPINE_VERSION=3.23.0
ALPINE_VER_SHA=51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375
CHANGE_COUNTER=1
IMAGE_TAG=$(ALPINE_VERSION)-$(CHANGE_COUNTER)
IMAGE_NAME=registry.cloudogu.com/official/base
IMAGE_NAME_PRERELEASE=registry.cloudogu.com/prerelease_official/base
DOGUCTL_VERSION=0.14.0
DOGUCTL_VER_SHA=bb300b75634643d480d451e2562be1e18e6a47355b12a4c9c70d0d0c5b0cb667
MAKEFILES_VERSION=10.5.0

default: build

include build/make/variables.mk
include build/make/self-update.mk
include build/make/clean.mk
include build/make/bats.mk

.PHONY: info
info:
	@echo "version information ..."
	@echo "Image (release)   : $(IMAGE_NAME):$(IMAGE_TAG)"
	@echo "Image (prerelease): $(IMAGE_NAME_PRERELEASE):$(IMAGE_TAG)"

.PHONY: build
build:
	docker build \
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
