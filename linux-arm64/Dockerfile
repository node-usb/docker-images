FROM ghcr.io/prebuild/linux-arm64-lts:2.1.0
USER 0
COPY arm64/libudev.h ${QEMU_LD_PREFIX}/usr/include/
COPY arm64/libudev.so ${QEMU_LD_PREFIX}/usr/lib/
USER node
