FROM ghcr.io/prebuild/android-armv7:1
USER 0
COPY armel/libudev.h ${CROSS_ROOT}/sysroot/usr/include/
COPY armel/libudev.so ${CROSS_ROOT}/sysroot/usr/lib/
USER node
