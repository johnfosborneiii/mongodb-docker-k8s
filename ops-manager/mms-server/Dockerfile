############################################################
# Dockerfile to run MongoDB Enerprise
# Based on a CentOS Image
############################################################

FROM centos:centos7
MAINTAINER John Osborne <johnfosborneiii@gmail.com>

ENV container docker

ENV OPSMANAGER_VERSION=3.4.1.385-1
ENV OPSMANAGER_MONGO_APP=mongodb://mongod.apps.josborne.com:27017

ENV MONGOHOST https://downloads.mongodb.com/on-prem-mms/tar
ENV MONGOFILE mongodb-mms-${OPSMANAGER_VERSION}.x86_64
ENV WORKDIR /opt/mongodb/mms
ENV container docker
ENV HOME /home/mongo

RUN yum update -y; yum clean all
RUN yum -y install epel-release bind-utils; yum clean all
RUN yum -y install wget openssl; yum clean all
RUN yum -y install net-tools; yum clean all

RUN useradd -u 1001 --home-dir $HOME --create-home mongo

RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR
ENV PATH="$WORKDIR:${PATH}"

RUN wget -O $MONGOFILE.tgz $MONGOHOST/$MONGOFILE.tar.gz
RUN tar -xvzf $MONGOFILE.tgz
RUN mv $MONGOFILE/* .
RUN rm $MONGOFILE.tgz
RUN rm -r $MONGOFILE

RUN mkdir -p $HOME/.mongodb-mms/
COPY certs/gen.key $HOME/.mongodb-mms/gen.key
COPY certs/mms.apps.josborne.com.pem /etc/ssl/
COPY certs/mongorootCA.pem /etc/ssl/
COPY config/conf-mms.properties conf/conf-mms.properties
COPY config/mms.conf conf/mms.conf
COPY files/entrypoint.sh /opt/mongodb/mms/bin/
RUN sed -i "s|mongodb://127.0.0.1:27017/?maxPoolSize=150|${OPSMANAGER_MONGO_APP}/admin|g" conf/conf-mms.properties

RUN chown -R 1001:1001 $WORKDIR
RUN chown -R 1001:1001 /home/mongo/
RUN chmod +x /opt/mongodb/mms/bin/entrypoint.sh

USER 1001

EXPOSE 8080/tcp
EXPOSE 8443/tcp

CMD ["/opt/mongodb/mms/bin/entrypoint.sh"]
