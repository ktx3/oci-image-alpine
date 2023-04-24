# This is free and unencumbered software released into the public domain.

FROM scratch as build

ARG ALPINE_ROOTFS

# Install and update Alpine Linux with oci-build
ADD ["${ALPINE_ROOTFS}", "/"]
RUN \
    --mount=target=/tmp,type=tmpfs \
    --mount=target=/tmp/build,readwrite \
    --mount=target=/tmp/build/oci-build.sh,source=oci-build/oci-build.sh \
    --mount=target=/tmp/build/oci-entrypoint.sh,source=oci-entrypoint/oci-entrypoint.sh \
    ["sh", "-x", "/tmp/build/oci-build.sh"]

# Squash the root file system to a single layer
FROM scratch
COPY --from=build ["/", "/"]

# Enable the custom entrypoint
ENTRYPOINT ["/bin/sh", "/usr/local/bin/oci-entrypoint.sh"]
CMD ["/bin/sh"]
