ALPINE_VERSION="3.22.0"
ALPINE_VER_SHA="8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715"
CHANGE_COUNTER="1"
IMAGE_TAG="$(ALPINE_VERSION)-$(CHANGE_COUNTER)"
IMAGE_NAME="registry.cloudogu.com/official/base"
IMAGE_NAME_PRERELEASE="registry.cloudogu.com/prerelease_official/base"
DOGUCTL_VERSION="0.13.2"
MAKEFILES_VERSION="10.1.0"

default: build

WORKSPACE=/workspace
BATS_LIBRARY_DIR=$(TARGET_DIR)/bats_libs
TESTS_DIR=./unitTests
BASH_TEST_REPORT_DIR=$(TARGET_DIR)/shell_test_reports
BASH_TEST_REPORTS=$(BASH_TEST_REPORT_DIR)/TestReport-*.xml
BATS_ASSERT=$(BATS_LIBRARY_DIR)/bats-assert
BATS_MOCK=$(BATS_LIBRARY_DIR)/bats-mock
BATS_SUPPORT=$(BATS_LIBRARY_DIR)/bats-support
BATS_FILE=$(BATS_LIBRARY_DIR)/bats-file
BATS_BASE_IMAGE?=bats/bats
BATS_CUSTOM_IMAGE?=cloudogu/bats
BATS_TAG?=1.2.1

include build/make/variables.mk
include build/make/self-update.mk
include build/make/clean.mk

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

.PHONY unit-test-shell:
unit-test-shell: unit-test-shell-$(ENVIRONMENT)

$(BATS_ASSERT):
	@git clone --depth 1 https://github.com/bats-core/bats-assert $@

$(BATS_MOCK):
	@git clone --depth 1 https://github.com/grayhemp/bats-mock $@

$(BATS_SUPPORT):
	@git clone --depth 1 https://github.com/bats-core/bats-support $@

$(BATS_FILE):
	@git clone --depth 1 https://github.com/bats-core/bats-file $@

$(BASH_SRC):
	BASH_SRC:=$(shell find "${WORKDIR}" -type f -name "*.sh")

${BASH_TEST_REPORT_DIR}: $(TARGET_DIR)
	@mkdir -p $(BASH_TEST_REPORT_DIR)

unit-test-shell-ci: $(BASH_SRC) $(BASH_TEST_REPORT_DIR) $(BATS_ASSERT) $(BATS_MOCK) $(BATS_SUPPORT) $(BATS_FILE)
	@echo "Test shell units on CI server"
	@make unit-test-shell-generic

unit-test-shell-local: $(BASH_SRC) $(PASSWD) $(ETCGROUP) $(HOME_DIR) buildTestImage $(BASH_TEST_REPORT_DIR) $(BATS_ASSERT) $(BATS_MOCK) $(BATS_SUPPORT) $(BATS_FILE)
	@echo "Test shell units locally (in Docker)"
	@docker run --rm \
		-v $(HOME_DIR):/home/$(USER) \
		-v $(WORKDIR):$(WORKSPACE) \
		-w $(WORKSPACE) \
		--entrypoint="" \
		$(BATS_CUSTOM_IMAGE):$(BATS_TAG) \
		${TESTS_DIR}/customBatsEntrypoint.sh make unit-test-shell-generic

unit-test-shell-generic:
	@bats --formatter junit --output ${BASH_TEST_REPORT_DIR} ${TESTS_DIR}

.PHONY buildTestImage:
buildTestImage:
	@echo "Build shell test container"
	@cd ${TESTS_DIR} && docker build \
		--build-arg=BATS_BASE_IMAGE=${BATS_BASE_IMAGE} \
		--build-arg=BATS_TAG=${BATS_TAG} \
		-t ${BATS_CUSTOM_IMAGE}:${BATS_TAG} \
		.
