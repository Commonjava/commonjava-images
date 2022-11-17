FROM quay.io/openshift/origin-jenkins-agent-maven:4.10

LABEL org.opencontainers.image.authors="RedHat SPMM Team <nos@redhat.com>"

USER root

ENV MVN_VER 3.8.6

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV M2_HOME /opt/apache-maven-${MVN_VER}
ENV PATH ${M2_HOME}/bin:${PATH}

ADD https://mirror.olnevhost.net/pub/apache/maven/maven-3/${MVN_VER}/binaries/apache-maven-${MVN_VER}-bin.tar.gz /tmp/maven.tar.gz
RUN tar -zxf /tmp/maven.tar.gz -C /opt
RUN cat /etc/redhat-release

RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    ls -l /opt && \
    mvn --version

USER 1001