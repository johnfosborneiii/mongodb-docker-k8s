# Dockerizing CentOS: Dockerfile for building MongoDB images.
# Based on centos:7, creates initial group & user account.

FROM centos:7

# Environment variables
ENV LANG="en_US.UTF-8" \
    TERM="xterm" \
    MONGODB_IMAGE_NAME="mongodb-base-7/base" \
    MONGODB_IMAGE_VERSION="1.1" \
    MONGODB_IMAGE_RELEASE="1" \
    HOME="/var/lib/mongodb"

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
                   wget                 && \
    yum clean all

# Create a user and group used to launch processes
RUN groupadd -r mongod -g 184 && \
    useradd -u 184 -r -g mongod -m -d $HOME -s /sbin/nologin mongod

USER mongod

WORKDIR /var/lib/mongodb
