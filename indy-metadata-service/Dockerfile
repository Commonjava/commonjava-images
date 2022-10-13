FROM quay.io/factory2/nos-java-base:latest

USER root

ADD setup-user.sh /usr/local/bin/setup-user.sh
ADD setup-user.sh /etc/profile.d/setup-user.sh
ADD passwd.template /opt/passwd.template

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

#RUN yum -y install java-11-openjdk-devel
RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -P /tmp http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7/os/x86_64/ && \
    yum -y install java-11-openjdk-devel.x86_64

RUN mkdir -p /deployment/log /deployment/config && \
  chmod -R 777 /deployment/log /deployment/config && \
  echo "Pulling jar from: $tarball_url" && \
  wget $tarball_url -O /deployment/indy-metadata-service-runner.jar

ADD start-service.sh /deployment/start-service.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-service.sh"]
