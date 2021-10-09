# Node USB Docker Images

**Docker images for cross compiling prebuilt binaries for Node.js. Used by [`prebuildify-cross`](https://github.com/prebuild/prebuildify-cross).**

[![Actions](https://github.com/node-usb/docker-images/workflows/release/badge.svg)](https://github.com/node-usb/docker-images/actions)

## About

Mainly extensions of the existing [prebuild docker images](https://github.com/prebuild/docker-images) adding explicit build dependencies for Node USB.

## Images

- [centos7-devtoolset7](https://github.com/node-usb/docker-images/pkgs/container/centos7-devtoolset7) creates `linux-x64/node.napi.glibc.node`
- [alpine](https://github.com/node-usb/docker-images/pkgs/container/alpine) creates `linux-x64/node.napi.musl.node`
- [linux-x86](https://github.com/node-usb/docker-images/pkgs/container/linux-x86) creates `linux-x86/node.napi.node`
- [linux-armv6](https://github.com/node-usb/docker-images/pkgs/container/linux-armv6) creates `linux-arm/node.napi.armv6.node`
- [linux-armv7](https://github.com/node-usb/docker-images/pkgs/container/linux-armv7) creates `linux-arm/node.napi.armv7.node`
- [linux-arm64](https://github.com/node-usb/docker-images/pkgs/container/linux-arm64) creates `linux-arm64/node.napi.armv8.node`
- [android-armv7](https://github.com/node-usb/docker-images/pkgs/container/android-armv7) creates `android-arm/node.napi.armv7.node`
- [android-arm64](https://github.com/node-usb/docker-images/pkgs/container/android-arm64) creates `android-arm64/node.napi.armv8.node`
