# Dockerizing MongoDB: Dockerfile for building Ops Manager images.
# Based on mongodb-base-7/base:1.1, installs opm via an archive (.tar) file.

FROM mongodb-base-7/base:1.1

# Environment variables
ENV MONGODB_IMAGE_NAME="mongodb-base-7/opm" \
    MONGODB_IMAGE_VERSION="1.1" \
    MONGODB_IMAGE_RELEASE="1" \
    MONGODB_HOME="/opt/mongodb/opm"

# Kubernetes labels
LABEL io.k8s.description="MongoDB Ops Manager is a service for managing, monitoring and backing up a MongoDB infrastructure." \
      io.k8s.display-name="MongoDB Ops Manager $MONGODB_VERSION" \
      io.openshift.expose-services="80:opm" \
      io.openshift.tags="ops,manager,mongodb,mongodb$MONGODB_VERSION,opm"

# Build labels
LABEL Name="$MONGODB_IMAGE_NAME" \
      Version="$MONGODB_IMAGE_VERSION" \
      Release="$MONGODB_IMAGE_RELEASE" \
      Architecture="x86_64" \
      BZComponent="mongodb-base-7-opm-docker" \
      Authors="John Osborne <johnfosborneiii@gmail.com>, Michael Surbey <msurbey@redhat.com>"

USER root

# Setup install
RUN mkdir -p $MONGODB_HOME && \
    echo "export PATH=\$MONGODB_HOME:\$PATH" >> /etc/default/opm && \
    curl -L 'https://downloads.mongodb.com/on-prem-opm/tar/mongodb-opm-3.4.3.402-1.x86_64.tar.gz' | tar -xzf - -C $MONGODB_HOME --strip 1

# Copy file, directory, etc.
ADD root /

# Change ownership
RUN chown -R mongo:mongo $MONGODB_HOME && \
    chown -R mongo:mongo $HOME

EXPOSE 8080 8443

USER mongo

# CMD ["/opt/mongodb/opm/bin/entrypoint.sh"]
CMD ["/opt/mongodb/opm/bin/mongodb-opm", "start"]
