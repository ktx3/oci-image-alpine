# This is free and unencumbered software released into the public domain.

FROM scratch

ARG ALPINE_ROOTFS

# Install and update Alpine Linux with oci-build
ADD ["${ALPINE_ROOTFS}", "/"]
COPY ["oci-build/oci-build.sh", "oci-entrypoint/oci-entrypoint.sh", "oci-build-config.sh", "packages.txt", "/tmp/"]
RUN ["sh", "-x", "/tmp/oci-build.sh"]

# Enable the custom entrypoint
ENTRYPOINT ["/bin/sh", "/usr/local/bin/oci-entrypoint.sh"]
CMD ["/bin/sh"]
