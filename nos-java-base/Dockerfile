# Uncomment this for community builds
#FROM centos:7
#ARG ver=1.9.3
#ARG tarball_url=https://github.com/Commonjava/indy/releases/download/indy-parent-$ver/indy-launcher-$ver-skinny.tar.gz

# Build from a RHEL 7.6 tag for now since the our Openshift nodes are on
# RHEL 7.6 and can only provide RHEL 7.6 rpms to our image
FROM registry.access.redhat.com/rhel7:7.6-362

LABEL io.openshift.sti.scripts-url="image:///usr/local/sti" \
    io.openshift.s2i.scripts-url="image:///usr/local/sti" \
    Component="nos-sti-base" \
    Name="nos-java-base" \
    Version="7" \
    Release="1"

MAINTAINER NOS

USER root

ENV TZ UTC

ADD Eng_Ops_CA.crt /etc/pki/ca-trust/source/anchors/Eng_Ops_CA.crt
ADD Red_Hat_IS_CA.crt /etc/pki/ca-trust/source/anchors/Red_Hat_IS_CA.crt
ADD RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
RUN update-ca-trust extract

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init

RUN yum -y update && \
    yum -y install wget git tar which curl tree java-1.8.0-openjdk-devel net-tools lsof iotop && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN chmod +x /usr/local/bin/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/start.sh"]
