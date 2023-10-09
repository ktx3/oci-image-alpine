#!/bin/sh
# This is free and unencumbered software released into the public domain.

# OCI container image build script

set -e -u

# Change to the script directory
cd -- "$(dirname -- "${0:?}")"

pre_install() { :; }
post_install() { :; }

# Custom config
! test -e oci-build-config.sh || . ./oci-build-config.sh

# Default config
: "${PKG:=apk}"
: "${UPGRADE:=}"

# Install system packages
pre_install
if test -e packages.txt; then
    packages="$(grep . <packages.txt || :)"
    case "${PKG:?}" in
        apk)
            test -z "${UPGRADE:-}" || apk --no-cache upgrade
            test -z "${packages:-}" || apk --no-cache add ${packages:-}
            ;;

        apt)
            if test -n "${UPGRADE:-}" || test -n "${packages:-}"; then
                apt-get update
            fi
            test -z "${UPGRADE:-}" || apt-get -y dist-upgrade
            test -z "${packages:-}" || apt-get install -y ${packages:-}
            apt-get -y clean
            ;;

        dnf|microdnf|yum)
            test -z "${UPGRADE:-}" || "${PKG:?}" update -y
            test -z "${packages:-}" || "${PKG:?}" install -y ${packages:-}
            "${PKG:?}" clean all
            ;;

        *)
            printf 'oci-build.sh: error: unhandled PKG: %s\n' "${PKG:?}" >&2
            exit 1
            ;;
    esac
fi
post_install

# Install the custom container entrypoint if provided
if test -e oci-entrypoint.sh; then
    mkdir -p /usr/local/bin
    cp oci-entrypoint.sh /usr/local/bin/
    chmod +x /usr/local/bin/oci-entrypoint.sh
fi
! test -e oci-entrypoint-config.sh || cp oci-entrypoint-config.sh /etc/
