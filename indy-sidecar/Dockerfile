FROM quay.io/factory2/nos-java-base:latest

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN yum -y install java-11-openjdk-devel

RUN mkdir -p /opt/indy-sidecar/log /home/indy && \
  chmod -R 777 /opt/indy-sidecar && \
  chmod -R 777 /opt/indy-sidecar/log && \
  echo "Pulling jar from: $tarball_url" && \
  wget $tarball_url -O /opt/indy-sidecar/indy-sidecar-runner.jar

RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-sidecar && \
    chmod -R g=u /opt/indy-sidecar && \
    chgrp -R 0 /opt/indy-sidecar/log && \
    chmod -R g=u /opt/indy-sidecar/log && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
