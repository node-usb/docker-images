FROM ghcr.io/prebuild/linux-armv6:1
USER 0
COPY armhf/libudev.h ${CROSS_ROOT}/sysroot/usr/include/
COPY armhf/libudev.so ${CROSS_ROOT}/sysroot/usr/lib/
USER node
