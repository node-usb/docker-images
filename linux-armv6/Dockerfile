FROM ghcr.io/prebuild/linux-armv6:2.1.0
USER 0
COPY armhf/libudev.h ${QEMU_LD_PREFIX}/usr/include/
COPY armhf/libudev.so ${QEMU_LD_PREFIX}/usr/lib/
USER node
