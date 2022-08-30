# This is free and unencumbered software released into the public domain.

# Get the image version to be built

set -e -u

# Change to the script directory
cd -- "$(dirname -- "${0:?}")"

# Return the version from the lockfile, if it exists, or get the latest
if test -e version.lock; then
    cat version.lock
    exit 0
fi

: "${ALPINE_ARCH:=x86_64}"
: "${ALPINE_RELEASES_URL:=https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/${ALPINE_ARCH:?}/latest-releases.yaml}"

curl \
    --fail \
    --location \
    --show-error \
    --silent \
    --url "${ALPINE_RELEASES_URL:?}" \
| grep -E -e 'alpine-minirootfs-[^\-]+-[^\.]+\.tar\.gz' \
| head -n 1 \
| cut -d - -f 3 \
| tee version.lock
