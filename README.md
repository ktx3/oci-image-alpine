# Alpine Linux OCI container base image

This is free and unencumbered software released into the public domain.

The image is built from an Alpine Linux minirootfs tarball with the following
modifications:

- System packages are updated
- Some additional system packages are installed (see `packages.txt`)
- A custom container entrypoint is installed (see `oci-entrypoint`)

To build the image:

    $ make

Verifying the minirootfs tarball requires the Alpine Linux GnuPG signing key:

    pub   rsa4096/0x293ACD0907D9495A 2014-12-10 [SC]
          Key fingerprint = 0482 D840 22F5 2DF1 C4E7  CD43 293A CD09 07D9 495A
    uid                              Natanael Copa <ncopa@alpinelinux.org>
    sub   rsa4096/0x9E2CE29C63FE7A06 2014-12-10 [E]
          Key fingerprint = 498A 2E7C 598F FE67 9664  16B1 9E2C E29C 63FE 7A06

The following variables can be set to customize the build (see
`oci-build/oci-build.mk` for other options):

- `ALPINE_ARCH`: Alpine Linux architecture (only `x86_64` is expected to work)
- `ALPINE_ROOTFS`: path to the downloaded minirootfs tarball
- `ALPINE_ROOTFS_SIG`: path to the downloaded minirootfs detached signature
- `ALPINE_URL`: Alpine Linux releases URL
- `ALPINE_VERSION`: Alpine Linux version to build
