# OCI container entrypoint

This is free and unencumbered software released into the public domain.

The `oci-entrypoint.sh` script provides a mechanism for dropping root
privileges within a container and ensuring that an unprivileged user exists
with the desired UID/GID.

## Usage

In a Dockerfile, install the script, and set it as the container's entrypoint:

    COPY ["oci-entrypoint.sh", "/usr/local/bin/"]
    ENTRYPOINT ["/bin/sh", "/usr/local/bin/oci-entrypoint.sh"]
    CMD ["/bin/sh"]

## Configuration

The entrypoint reads configuration from `/etc/oci-entrypoint-config.sh` if it
exists, or the following environment variables can be defined:

- `DISABLE_SETPRIV`: do not use `setpriv` for dropping root privileges
- `LEGACY_RUNUSER`: use old `runuser` syntax for dropping root privileges
- `USER_NAME`: unprivileged user name, or `root` to disable (default: `user`)
- `USER_UID`: unprivileged user UID (default: `1000`)
- `USER_GID`: unprivileged user GID (default: same as UID)
- `USER_HOME`: unprivileged user home directory (default: `/home/$USER_NAME`)
- `USER_PATH_PRE`: additional directories to add to the beginning of PATH
- `USER_PATH_POST`: additional directories to add to the end of PATH
