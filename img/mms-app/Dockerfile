# Dockerizing MongoDB: Dockerfile for building Ops Manager images.
# Based on mongodb-base-7/base:1.1, installs MMS via an archive (.tar) file.

FROM mongodb-base-7/base:1.1

# Environment variables
ENV MONGODB_IMAGE_NAME="mongodb-base-7/mms" \
    MONGODB_IMAGE_VERSION="1.1" \
    MONGODB_IMAGE_RELEASE="3" \
    MONGODB_HOME="/opt/mongodb/mms"

# Kubernetes labels
LABEL io.k8s.description="MongoDB Ops Manager is a service for managing, monitoring and backing up a MongoDB infrastructure." \
      io.k8s.display-name="MongoDB Ops Manager $MONGODB_VERSION" \
      io.openshift.expose-services="80:mms" \
      io.openshift.tags="ops,manager,mongodb,mongodb$MONGODB_VERSION,mms"

# Build labels
LABEL Name="$MONGODB_IMAGE_NAME" \
      Version="$MONGODB_IMAGE_VERSION" \
      Release="$MONGODB_IMAGE_RELEASE" \
      Architecture="x86_64" \
      BZComponent="mongodb-base-7-mms-docker" \
      Authors="John Osborne <johnfosborneiii@gmail.com>, Michael Surbey <msurbey@redhat.com>"

USER root

# Copy file, directory, etc.
ADD root /

# Setup install
RUN curl -L 'https://downloads.mongodb.com/on-prem-mms/tar/mongodb-mms-3.4.3.402-1.x86_64.tar.gz' | tar -xzf - -C $MONGODB_HOME --strip 1 && \
    ln -s $MONGODB_HOME/bin/* /usr/bin/

# Change ownership
RUN chown -R mongod:0 $MONGODB_HOME && \
    chown -R mongod:0 $HOME

EXPOSE 8080 8443

# Data directory
VOLUME ["/var/lib/mongodb/data"]

USER mongod

ENTRYPOINT ["container-entrypoint"]
CMD ["run-mongod"]
