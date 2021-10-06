FROM ghcr.io/prebuild/android-arm64:1
USER 0
COPY arm64/libudev.h ${QEMU_LD_PREFIX}/usr/include/
COPY arm64/libudev.so ${QEMU_LD_PREFIX}/usr/lib/
USER node
