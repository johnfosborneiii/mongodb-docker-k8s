# Dockerizing MongoDB: Dockerfile for building MongoDB Enterprise images.
# Based on mongodb-base-7/base:1.1, installs MongoDB via an archive (.tgz) file.

FROM mongodb-base-7/base:1.1

# Environment variables
ENV MONGODB_IMAGE_NAME="mongodb-base-7/mongodb" \
    MONGODB_IMAGE_VERSION="1.1" \
    MONGODB_IMAGE_RELEASE="14" \
    MONGODB_VERSION="3.4" \
    MONGODB_HOME="/opt/mongodb" \
    MONGODB_DATADIR="/var/lib/mongodb/data" \
    MONGODB_CONFIG_PATH="/etc/mongod.conf" \
    MONGODB_LOG_PATH="/var/log/mongodb" \
    MONGODB_STORAGE_ENGINE="mmapv1" \
    MONGODB_PID_FILE_PATH="/var/run/mongodb" \
    CONTAINER_SCRIPTS_PATH="/usr/share/mongodb"

# Kubernetes labels
LABEL io.k8s.description="MongoDB is a scalable, high-performance, open source NoSQL database." \
      io.k8s.display-name="MongoDB $MONGODB_VERSION" \
      io.openshift.expose-services="27017:mongodb" \
      io.openshift.tags="database,mongodb,mongodb$MONGODB_VERSION"

# Build labels
LABEL Name="$MONGODB_IMAGE_NAME" \
      Version="$MONGODB_IMAGE_VERSION" \
      Release="$MONGODB_IMAGE_RELEASE" \
      Architecture="x86_64" \
      BZComponent="mongodb-base-7-mongodb-docker" \
      Authors="John Osborne <johnfosborneiii@gmail.com>, Michael Surbey <msurbey@redhat.com>"

USER root

# Install packages
RUN yum -y install --setopt=tsflags=nodocs \
                   cyrus-sasl              \
                   cyrus-sasl-plain        \
                   cyrus-sasl-gssapi       \
                   krb5-libs               \
                   libcurl                 \
                   lm_sensors-libs         \
                   net-snmp-agent-libs     \
                   net-snmp                \
                   openssl                 \
                   rpm-libs                \
                   tcp_wrappers-libs    && \
    yum clean all

# Copy file, directory, etc.
ADD root /

# Install mongod
RUN curl -L 'https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel70-3.4.2.tgz' | tar -xzf - -C $MONGODB_HOME --strip 1 && \
    ln -s $MONGODB_HOME/bin/* /usr/bin/ && \
    touch $MONGODB_CONFIG_PATH && \
    chown mongod:0 $MONGODB_CONFIG_PATH && \
    chown -R mongod:0 $HOME && \
    chown -R mongod:0 $MONGODB_HOME && \
    chown -R mongod:0 $MONGODB_DATADIR && \
    chown -R mongod:0 $MONGODB_LOG_PATH && \
    chown -R mongod:0 $MONGODB_PID_FILE_PATH && \
    chmod -R a+rwx $MONGODB_HOME && \
    chmod -R g+rwx $HOME && \
    chmod -R 0755 $MONGODB_PID_FILE_PATH && \
    /usr/libexec/reset-perms /etc/mongod.conf

EXPOSE 27017

# Data directory
VOLUME ["/var/lib/mongodb/data"]

USER mongod

ENTRYPOINT ["container-entrypoint"]
CMD ["run-mongod"]
