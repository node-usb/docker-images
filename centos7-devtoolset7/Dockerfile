FROM ghcr.io/prebuild/centos7-devtoolset7:2.1.0
USER 0

RUN sed -i 's/#! \/usr\/bin\/python/#! \/usr\/bin\/python2/' /usr/libexec/urlgrabber-ext-down && \
yum install -y libudev-devel

USER node
