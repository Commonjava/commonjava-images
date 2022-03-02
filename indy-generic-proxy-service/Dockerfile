FROM quay.io/factory2/nos-java-base:latest

USER root

#RUN yum -y install java-11-openjdk-devel
RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -P /tmp http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7/os/x86_64/ && \
    yum -y install java-11-openjdk-devel.x86_64

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment/log && \
  echo "Pulling jar from: $tarball_url" && \
  wget $tarball_url -O /deployment/indy-generic-proxy-service-runner.jar

ADD start-service.sh /deployment/start-service.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-service.sh"]
