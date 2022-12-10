FROM ghcr.io/prebuild/linux-armv7:2.1.0
USER 0
COPY armel/libudev.h ${QEMU_LD_PREFIX}/usr/include/
COPY armel/libudev.so ${QEMU_LD_PREFIX}/usr/lib/
USER node
