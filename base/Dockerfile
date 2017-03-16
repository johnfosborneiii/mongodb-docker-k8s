# Dockerizing CentOS: Dockerfile for building MongoDB images.
# Based on centos:7, creates initial group & user account.

FROM centos:7

# Environment variables
ENV LANG="en_US.UTF-8" \
    TERM="xterm" \
    MONGODB_IMAGE_NAME="mongodb-base-7/base" \
    MONGODB_IMAGE_VERSION="1.1" \
    MONGODB_IMAGE_RELEASE="2" \
    MONGODB_VERSION="3.4" \
    HOME="/home/mongo"

# Build labels
LABEL Name="$MONGODB_IMAGE_NAME" \
      Version="$MONGODB_IMAGE_VERSION" \
      Release="$MONGODB_IMAGE_RELEASE" \
      Architecture="x86_64" \
      BZComponent="mongodb-base-7-base-docker" \
      Authors="Michael Surbey <msurbey@redhat.com>"

USER root

# Install packages
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install centos-release-scl-rh && \
    yum -y install --setopt=tsflags=nodocs \
                   bind-utils              \
                   gettext                 \
                   iproute                 \
                   net-tools               \
                   openssl                 \
                   wget                 && \
    yum clean all

# Systemd cleanup
RUN (cd /lib/systemd/system/sysinit.target.wants && for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -vf $i; done) && \
    rm -vf /lib/systemd/system/multi-user.target.wants/* && \
    rm -vf /etc/systemd/system/*.wants/* && \
    rm -vf /lib/systemd/system/local-fs.target.wants/* && \
    rm -vf /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -vf /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -vf /lib/systemd/system/basic.target.wants/* && \
    rm -vf /lib/systemd/system/anaconda.target.wants/*

# Create a user and group used to launch processes
RUN groupadd -r mongo -g 184 && \
    useradd -u 184 -r -g mongo -m -d $HOME -s /sbin/nologin -c "Mongo user" mongo

USER mongo

WORKDIR /home/mongo
