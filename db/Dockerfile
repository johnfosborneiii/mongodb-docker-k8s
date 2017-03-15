############################################################
# Dockerfile to run MongoDB Enerprise
# Based on a CentOS Image
############################################################

FROM centos:centos7
MAINTAINER John Osborne <johnfosborneiii@gmail.com>

ENV MONGOHOST https://fastdl.mongodb.org/linux
ENV MONGOFILE mongodb-linux-x86_64-rhel70-3.4.1
ENV WORKDIR /opt/mongodb
ENV DATADIR $WORKDIR/data
ENV container docker
ENV HOME /home/mongo

RUN yum update -y; yum clean all
RUN yum -y install epel-release bind-utils; yum clean all
RUN yum -y install wget; cyrus-sasl cyrus-sasl-plain cyrus-sasl-gssapi krb5-libs \
            lm_sensors-libs net-snmp-agent-libs net-snmp openssl rpm-libs \
            tcp_wrappers-libs; yum clean all

RUN useradd -u 1001 --home-dir $HOME --create-home mongo

RUN mkdir -p $WORKDIR
RUN mkdir -p $DATADIR

WORKDIR $WORKDIR
ENV PATH="$WORKDIR:${PATH}"

RUN wget -O $MONGOFILE.tgz $MONGOHOST/$MONGOFILE.tgz
RUN tar -xvzf $MONGOFILE.tgz
RUN mv $MONGOFILE/* .
RUN rm $MONGOFILE.tgz
RUN rm -r $MONGOFILE

RUN mkdir -p $HOME/.mongodb-mms/
COPY files/gen.key $HOME/.mongodb-mms/gen.key
COPY files/mongo.apps.josborne.com.pem /etc/ssl/

RUN chown -R 1001:1001 $WORKDIR
RUN chown -R 1001:1001 /home/mongo/

USER 1001

EXPOSE 27017
VOLUME ["$DATADIR"]

CMD ["bin/mongod", "--dbpath=/opt/mongodb/data", "--sslMode=requireSSL", "--sslPEMKeyFile=/etc/ssl/mongo.apps.josborne.com.pem"]
