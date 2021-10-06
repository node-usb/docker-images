FROM ghcr.io/prebuild/linux-armv6:1
USER 0
COPY armhf/libudev.h ${QEMU_LD_PREFIX}/usr/include/
COPY armhf/libudev.so ${QEMU_LD_PREFIX}/usr/lib/
USER node
