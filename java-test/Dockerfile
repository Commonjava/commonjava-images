# Uncomment this for community builds
FROM fedora-minimal

# Build from a RHEL 7.6 tag for now since the our Openshift nodes are on
# RHEL 7.6 and can only provide RHEL 7.6 rpms to our image
#FROM registry.access.redhat.com/rhel7:7.6-362

MAINTAINER SPMM

USER root

ENV TZ UTC

ADD Eng_Ops_CA.crt /etc/pki/ca-trust/source/anchors/Eng_Ops_CA.crt
ADD Red_Hat_IS_CA.crt /etc/pki/ca-trust/source/anchors/Red_Hat_IS_CA.crt
ADD RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
RUN update-ca-trust extract

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init

RUN microdnf -y update && \
    microdnf -y install tar which curl tree java-1.8.0-openjdk-devel && \
    microdnf clean all

ADD start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/start.sh"]
#ENTRYPOINT /bin/bash