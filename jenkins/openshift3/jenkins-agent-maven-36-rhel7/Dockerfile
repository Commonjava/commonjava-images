FROM openshift3/jenkins-agent-maven-35-rhel7

MAINTAINER NOS <nos@redhat.com>

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV M2_HOME $HOME/apache-maven-3.6.3
ENV PATH ${M2_HOME}/bin:${PATH}

ADD https://mirror.olnevhost.net/pub/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz /tmp/maven.tar.gz
RUN tar -zxf /tmp/maven.tar.gz -C $HOME
