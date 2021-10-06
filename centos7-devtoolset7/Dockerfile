FROM centos/devtoolset-7-toolchain-centos7:7

USER 0

RUN groupadd -g 1000 node && useradd -g 1000 -u 1000 -m node && \
  curl -fsSL https://rpm.nodesource.com/setup_8.x | bash - && \
  yum install -y make libudev-devel nodejs && \
  npm -v

USER node

WORKDIR /app
