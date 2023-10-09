# This is free and unencumbered software released into the public domain.

# OCI container makefile
#
# Required:
#
# - IMAGE_NAME: name used in tagging
#
# Optional:
#
# - BUILD: image build command
# - BUILD_OPTS: all options passed to the image build command
# - BUILD_OPTS_EXTRA: extra options passed to the image build command
# - ENABLE_CACHE: set to true to enable build cache
# - IMAGE_REGISTRY: registry prefix used in tagging (default: `localhost/`)
# - IMAGE_TAG: full image tag
# - IMAGE_VERSION: image version used in tagging (default: `latest`)
#
# Defined for use in parent makefile:
#
# - CURL: download command
# - CURL_OPTS: all options passed to the download command
# - CURL_OPTS_EXTRA: extra options passed to the download command
# - DOCKER_COMPOSE: docker compose command
# - GPG: gpg command

# Constants
override TRUE := true t yes y 1

# Required variables
assert-set = $(if $(strip $($(1))),,$(error required variable not set: $(1)))
$(call assert-set,IMAGE_NAME)

# Optional variables
IMAGE_REGISTRY ?= localhost/
IMAGE_TAG ?= $(IMAGE_REGISTRY)$(IMAGE_NAME):$(IMAGE_VERSION)
IMAGE_VERSION ?= latest

BUILD ?= docker image build
BUILD_OPTS ?= --force-rm --tag=$(IMAGE_TAG) \
    $(if $(filter $(TRUE),$(ENABLE_CACHE)),,--no-cache) \
    $(BUILD_OPTS_EXTRA)

# Defined variables
CURL ?= curl
CURL_OPTS ?= --fail --location --show-error --silent $(CURL_OPTS_EXTRA)
DOCKER_COMPOSE ?= docker compose
GPG ?= gpg

# Target recipes
.DEFAULT_GOAL := all
.PHONY: all build

all: build

build:
	$(BUILD) $(BUILD_OPTS) -- .
