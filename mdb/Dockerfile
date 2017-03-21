# Dockerizing MongoDB: Dockerfile for building MongoDB Enterprise images.
# Based on mongodb-base-7/base:1.1, installs MongoDB via an archive (.tgz) file.

FROM mongodb-base-7/base:1.1

# Environment variables
ENV MONGODB_IMAGE_NAME="mongodb-base-7/mongodb" \
    MONGODB_IMAGE_VERSION="1.1" \
    MONGODB_IMAGE_RELEASE="1" \
    MONGODB_HOME="/opt/mongodb"

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

# Setup install
RUN mkdir -p $MONGODB_HOME  && \
    echo "export PATH=\$MONGODB_HOME:\$PATH" >> /etc/default/mongodb && \
    curl -L 'https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel70-3.4.2.tgz' | tar -xzf - -C $MONGODB_HOME --strip 1

# Copy file, directory, etc.
ADD root /

# Change ownership
RUN chown -R mongo:mongo $MONGODB_HOME && \
    chown -R mongo:mongo $HOME

EXPOSE 27017

VOLUME ["/opt/mongodb/data"]

USER mongo

CMD ["/opt/mongodb/bin/mongod", "--dbpath=/opt/mongodb/data", "--sslMode=requireSSL", "--sslPEMKeyFile=/etc/ssl/mongo.apps.josborne.com.pem"]
