ALPINE_VERSION=3.23.3
ALPINE_VER_SHA=25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
CHANGE_COUNTER=1
IMAGE_TAG=$(ALPINE_VERSION)-$(CHANGE_COUNTER)
IMAGE_NAME=registry.cloudogu.com/official/base
IMAGE_NAME_PRERELEASE=registry.cloudogu.com/prerelease_official/base
DOGUCTL_VERSION=0.14.0
DOGUCTL_VER_SHA=1f1a17f87a6afb7a3eb886f9e3a07da7ac7b1503e7ae232d496d01b417e07df1
MAKEFILES_VERSION=10.5.0

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
