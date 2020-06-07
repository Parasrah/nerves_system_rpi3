# 8b44338ec5c290b9b4ed2e1acb4377fbdd6375e7

# This Dockerfile generates the docker image that gets used by Gitlab CI
# To build it (YYYYMMDD.HHMM is the current date and time in UTC):
#   sudo docker build -t buildroot/base:YYYYMMDD.HHMM support/docker
#   sudo docker push buildroot/base:YYYYMMDD.HHMM

# We use a specific tag for the base image *and* the corresponding date
# for the repository., so do not forget to update the apt-sources.list
# file that is shipped next to this Dockerfile.
FROM elixir:1.10.3

LABEL maintainer="parasrah" \
      description="Container with everything needed to customize Nerves system"

# The container has no package lists, so need to update first
RUN dpkg --add-architecture i386 && \
    apt-get update -y
RUN apt-get install -y --no-install-recommends \
        automake \
        autoconf \
        squashfs-tools \
        ssh-askpass \
        pkg-config \
        curl \
        libssl-dev \
        m4 \
        python \
        bc \
        build-essential \
        bzr \
        ca-certificates \
        cmake \
        cpio \
        cvs \
        file \
        g++-multilib \
        git \
        libc6:i386 \
        libncurses5-dev \
        locales \
        mercurial \
        python-flake8 \
        python-nose2 \
        python-pexpect \
        python3 \
        python3-nose2 \
        python3-pexpect \
        qemu-system-arm \
        qemu-system-x86 \
        rsync \
        subversion \
        unzip \
        wget \
        && \
    apt-get -y autoremove && \
    apt-get -y clean

# To be able to generate a toolchain with locales, enable one UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen

RUN useradd -ms /bin/bash br-user && \
    chown -R br-user:br-user /home/br-user && \
    mkdir -p /home/br-user/app

USER br-user
WORKDIR /home/br-user/app
ENV HOME /home/br-user
ENV LC_ALL en_US.UTF-8
ENV MIX_HOME /home/br-user/.mix

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex nerves_bootstrap --force
