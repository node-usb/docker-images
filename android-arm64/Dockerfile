FROM ghcr.io/prebuild/android-arm64:2.1.0
USER 0
COPY arm64/libudev.h ${CROSS_ROOT}/sysroot/usr/include/
COPY arm64/libudev.so ${CROSS_ROOT}/sysroot/usr/lib/
USER node
