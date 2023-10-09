# OCI container image build framework

This is free and unencumbered software released into the public domain.

The `oci-build.sh` script and `oci-build.mk` makefile provide a framework for
building OCI container images using drop-in shell scripts to replace multiline
Dockerfile RUN commands.

This repository provides a simple framework for building OCI container images
using Docker tools and drop-in configuration files instead of complicated RUN
commands.

## Usage

In a Dockerfile, run the script from a bind mount:

    RUN --mount=target=/work ["sh", "/work/oci-build.sh"]

In a makefile, define the image name before including `oci-build.mk`:

    IMAGE_NAME ?= example
    include oci-build.mk

## Configuration

The build script reads configuration from `oci-build-config.sh` if it exists,
which can be used to define:

- `pre_install` and `post_install` functions which are executed before/after
  installing system packages

- `PKG`: select the package manager (`apk` for Alpine, `apt` for Debian, or
  `yum` for RedHat)

- `UPGRADE`: if non-empty, upgrade existing system packages

New system packages can be installed by providing `packages.txt`, with one
package per line.

## Custom container entrypoint

The build script will install a custom container entrypoint if it exists:

- `oci-entrypoint.sh` copied to `/usr/local/bin`

- `oci-entrypoint-config.sh` copied to `/etc`
