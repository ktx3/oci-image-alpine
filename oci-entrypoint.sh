#!/bin/sh
# This is free and unencumbered software released into the public domain.

# OCI container entrypoint

set -e -u

# Custom config
! test -e /etc/oci-entrypoint-config.sh || . /etc/oci-entrypoint-config.sh

# Default config
: "${USER_NAME:=user}"
: "${USER_UID:=1000}"
: "${USER_GID:=${USER_UID:?}}"
: "${USER_HOME:=/home/${USER_NAME:?}}"

# Default environment
: "${LANG:=C.UTF-8}"
: "${LC_COLLATE:=C}"
: "${TZ:=UTC}"

# Set up the unprivileged user
if test root = "${USER_NAME:?}"; then
    USER_HOME=/root
elif id -u -- "${USER_NAME:?}" >/dev/null 2>&1; then
    # Update UID/GID of existing user
    USER_GID_OLD="$(id -g -- "${USER_NAME:?}")"
    if test "x${USER_GID_OLD:?}" != "x${USER_GID:?}"; then
        groupmod -g "${USER_GID:?}" -- "$(id -g -n -- "${USER_NAME:?}")"
        find / \
            -not \( -path /dev -prune \) \
            -not \( -path /proc -prune \) \
            -not \( -path /run -prune \) \
            -not \( -path /sys -prune \) \
            -gid "${USER_GID_OLD:?}" \
            -exec chgrp "${USER_GID:?}" '{}' +
    fi

    USER_UID_OLD="$(id -u -- "${USER_NAME:?}")"
    if test "x${USER_UID_OLD:?}" != "x${USER_UID:?}"; then
        usermod -u "${USER_UID:?}" -- "${USER_NAME:?}"
        find / \
            -not \( -path /dev -prune \) \
            -not \( -path /proc -prune \) \
            -not \( -path /run -prune \) \
            -not \( -path /sys -prune \) \
            -uid "${USER_UID_OLD:?}" \
            -exec chown "${USER_UID:?}" '{}' +
    fi
else
    # Create new group
    if ! getent group "${USER_GID:?}" >/dev/null; then
        groupadd -g "${USER_GID:?}" -- "${USER_NAME:?}"
    fi

    # Create new user (suppress warnings about existing home directory e.g.
    # when mounting volumes into it)
    useradd -m -g "${USER_GID:?}" -u "${USER_UID:?}" -- "${USER_NAME:?}" 2>/dev/null
fi

# Environment variables
HOME="${USER_HOME:?}"
USER="${USER_NAME:?}"
PATH="${HOME:?}/.local/bin:${PATH:?}"
test -z "${USER_PATH_PRE:-}" || PATH="${USER_PATH_PRE:?}:${PATH:?}"
test -z "${USER_PATH_POST:-}" || PATH="${PATH:?}:${USER_PATH_POST:?}"
export HOME LANG LC_COLLATE TZ USER

# Drop privileges
if test root = "${USER_NAME:?}"; then
    exec "${@}"
elif command -v setpriv >/dev/null && test -z "${DISABLE_SETPRIV:-}"; then
    setpriv \
        --clear-groups \
        --bounding-set=-all \
        --inh-caps=-all \
        "--regid=${USER_GID:?}" \
        "--reuid=${USER_UID:?}" \
        -- "${@}"
else
    printf 'oci-entrypoint.sh: warning: setpriv not available or disabled\n' >&2
    if test 0 -eq "${#}"; then
        runuser -s "${SHELL:-/bin/sh}" -- "${USER_NAME:?}"
    elif test -n "${LEGACY_RUNUSER:-}" || {
        test -e /etc/redhat-release \
        && grep -q -F -e 'CentOS release 6' -- /etc/redhat-release
    }; then
        runuser -- "${USER_NAME:?}" -c 'exec "${@}"' - "${@}"
    else
        runuser -u "${USER_NAME:?}" -- "${@}"
    fi
fi
