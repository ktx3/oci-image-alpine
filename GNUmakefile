# This is free and unencumbered software released into the public domain.

# Find new versions at https://www.alpinelinux.org/posts/
ALPINE_VERSION ?= 3.16.0

# Optional variables
ALPINE_ARCH ?= x86_64
ALPINE_ROOTFS ?= alpine-minirootfs-$(ALPINE_VERSION)-$(ALPINE_ARCH).tar.gz
ALPINE_ROOTFS_SIG ?= $(ALPINE_ROOTFS).asc
ALPINE_URL ?= https://dl-cdn.alpinelinux.org/alpine/v$(basename $(ALPINE_VERSION))/releases/$(ALPINE_ARCH)

# Common configuration
IMAGE_NAME ?= alpine
IMAGE_VERSION ?= $(firstword $(subst ., ,$(ALPINE_VERSION)))
include oci-build/oci-build.mk

# Target recipes
.PHONY: clean verify

build: BUILD_OPTS += --build-arg=ALPINE_ROOTFS=$(ALPINE_ROOTFS)
build: verify

clean:
	rm -f -- $(wildcard *.asc *.tar.gz)

verify: $(ALPINE_ROOTFS) $(ALPINE_ROOTFS_SIG)
	$(GPG) --verify $(ALPINE_ROOTFS_SIG) $(ALPINE_ROOTFS)

%.tar.gz %.asc:
	$(CURL) $(CURL_OPTS) -o $@ --url $(ALPINE_URL)/$@
