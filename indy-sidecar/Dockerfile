FROM quay.io/factory2/nos-java-base:latest

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -P /tmp http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7/os/x86_64/ && \
    yum install -y java-11-openjdk-devel.x86_64 gettext unzip

RUN mkdir -p /opt/indy-sidecar/log && \
  chmod -R 777 /opt/indy-sidecar && \
  chmod -R 777 /opt/indy-sidecar/log

RUN echo "Pulling jar from: $tarball_url"
ADD $tarball_url /opt/indy-sidecar/indy-sidecar-runner.jar
RUN chmod +r /opt/indy-sidecar/indy-sidecar-runner.jar

RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-sidecar && \
    chmod -R g=u /opt/indy-sidecar && \
    chgrp -R 0 /opt/indy-sidecar/log && \
    chmod -R g=u /opt/indy-sidecar/log

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
