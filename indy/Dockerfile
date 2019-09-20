# Uncomment this for community builds
#FROM centos:7
#ARG ver=1.9.3
#ARG tarball_url=https://github.com/Commonjava/indy/releases/download/indy-parent-$ver/indy-launcher-$ver-skinny.tar.gz

# Build from a RHEL 7.6 tag for now since the our Openshift nodes are on
# RHEL 7.6 and can only provide RHEL 7.6 rpms to our image
FROM registry.access.redhat.com/rhel7:7.6-362

LABEL io.openshift.sti.scripts-url="image:///usr/local/sti" \
    io.openshift.s2i.scripts-url="image:///usr/local/sti" \
    Component="pnc-sti-base" \
    Name="pnc/pnc-rhel-7-base" \
    Version="7" \
    Release="1"

ENV INDY_ETC_DIR /usr/share/indy/etc

MAINTAINER NOS

USER root

ENV TZ UTC

EXPOSE 8080 8081 8000

ADD Eng_Ops_CA.crt /etc/pki/ca-trust/source/anchors/Eng_Ops_CA.crt
ADD Red_Hat_IS_CA.crt /etc/pki/ca-trust/source/anchors/Red_Hat_IS_CA.crt
ADD RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
RUN update-ca-trust extract

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init

RUN yum -y update && \
    yum -y install wget git tar which curl tree java-1.8.0-openjdk-devel net-tools lsof iotop && \
    yum clean all && \
    rm -rf /var/cache/yum

ADD start-indy.py /usr/local/bin/start-indy.py

ADD $tarball_url /tmp/indy-launcher.tar.gz
RUN	tar -zxf /tmp/indy-launcher.tar.gz -C /opt

RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/start-indy.py"]

RUN mkdir -p /etc/indy && mkdir -p /var/log/indy && mkdir -p /usr/share/indy
RUN chmod -R 777 /etc/indy && chmod -R 777 /var/log/indy && chmod -R 777 /usr/share/indy

ADD lowOverhead.jfc /usr/share/indy/flightrecorder.jfc

# NCL-4814: set umask to 002 so that group permission is 'rwx'
# It works because in start-indy.py we invoke indy.sh with bash -l (login shell)
# that reads from /etc/profile
RUN echo "umask 002" >> /etc/profile

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /etc/indy && \
    chmod -R g=u /etc/indy && \
    chgrp -R 0 /var/log/indy && \
    chmod -R g=u /var/log/indy && \
    chgrp -R 0 /usr/share/indy && \
    chmod -R g=u /usr/share/indy

USER 1001
