# Uncomment this for community builds
#FROM quay.io/centos/centos:centos7

# Change base image to use ubi9
FROM registry.access.redhat.com/ubi9/ubi:9.4

LABEL io.openshift.sti.scripts-url="image:///usr/local/sti" \
    io.openshift.s2i.scripts-url="image:///usr/local/sti" \
    Component="nos-sti-base" \
    Name="nos-java-base" \
    Version="8" \
    Release="1" \
    maintainer="RedHat SPMM Team <nos-devel@redhat.com>"

USER root

ENV TZ UTC

ADD RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
ADD 2022-IT-Root-CA.pem /etc/pki/ca-trust/source/anchors/2022-IT-Root-CA.pem
RUN update-ca-trust extract

RUN dnf -y update && \
    dnf -y install git java-11-openjdk-devel && \
    dnf clean all && \
    rm -rf /var/cache/yum

ADD start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/*

USER 1001

ENTRYPOINT ["/usr/local/bin/start.sh"]
