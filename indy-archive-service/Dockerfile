FROM quay.io/factory2/nos-java-base:latest

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN yum -y install java-11-openjdk-devel

RUN mkdir -p /opt/indy-archive-service/log /home/indy && \
  chmod -R 777 /opt/indy-archive-service && \
  chmod -R 777 /opt/indy-archive-service/log && \
  echo "Pulling jar from: $tarball_url" && \
  wget $tarball_url -O /opt/indy-archive-service/indy-archive-service-runner.jar

RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-archive-service && \
    chmod -R g=u /opt/indy-archive-service && \
    chgrp -R 0 /opt/indy-archive-service/log && \
    chmod -R g=u /opt/indy-archive-service/log && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
