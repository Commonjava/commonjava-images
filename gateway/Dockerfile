FROM quay.io/factory2/nos-java-base:latest

USER root

#RUN yum -y install java-11-openjdk-devel
RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -q -P /tmp https://vault.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo https://vault.centos.org/centos/7/os/x86_64/ && \
    yum -y install java-11-openjdk-devel.x86_64 && \
    yum clean all

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment/log

RUN echo "Pulling jar from: $tarball_url"
# hadolint ignore=DL3020
ADD $tarball_url /deployment/gateway-runner.jar
RUN chmod +r /deployment/gateway-runner.jar

COPY start-gateway.sh /deployment/start-gateway.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-gateway.sh"]
