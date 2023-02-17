# This is free and unencumbered software released into the public domain.

ifndef ALPINE_ARCH
    export ALPINE_ARCH := $(shell uname -m)
    ifeq "arm64" "$(ALPINE_ARCH)"
        ALPINE_ARCH := aarch64
    endif
endif

ifndef ALPINE_VERSION
ALPINE_VERSION := $(shell $(SHELL) version.sh)
endif

# Optional variables
ALPINE_ROOTFS ?= alpine-minirootfs-$(ALPINE_VERSION)-$(ALPINE_ARCH).tar.gz
ALPINE_ROOTFS_SIG ?= $(ALPINE_ROOTFS).asc
ALPINE_URL ?= https://dl-cdn.alpinelinux.org/alpine/v$(basename $(ALPINE_VERSION))/releases/$(ALPINE_ARCH)

# Common configuration
IMAGE_NAME ?= alpine
IMAGE_VERSION ?= $(firstword $(subst ., ,$(ALPINE_VERSION)))
include oci-build/oci-build.mk

# Target recipes
.PHONY: clean update verify

build: BUILD_OPTS += --build-arg=ALPINE_ROOTFS=$(ALPINE_ROOTFS)
build: verify

clean:
	rm -f -- latest-releases.yaml version.lock $(wildcard *.asc *.tar.gz)

update:
	rm -f -- version.lock
	$(SHELL) version.sh

verify: $(ALPINE_ROOTFS) $(ALPINE_ROOTFS_SIG)
	$(GPG) --verify $(ALPINE_ROOTFS_SIG) $(ALPINE_ROOTFS)

%.tar.gz %.asc:
	$(CURL) $(CURL_OPTS) -o $@ --url $(ALPINE_URL)/$@
