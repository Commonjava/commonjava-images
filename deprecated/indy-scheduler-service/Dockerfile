FROM quay.io/factory2/nos-java-base:latest

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN yum -y install java-11-openjdk-devel && yum clean all

RUN mkdir -p /opt/indy-scheduler-service/log /home/indy && \
  chmod -R 777 /opt/indy-scheduler-service && \
  chmod -R 777 /opt/indy-scheduler-service/log

RUN echo "Pulling jar from: $tarball_url"
# hadolint ignore=DL3020
ADD $tarball_url /opt/indy-scheduler-service/indy-scheduler-service-runner.jar
RUN chmod +r /opt/indy-scheduler-service/indy-scheduler-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-scheduler-service && \
    chmod -R g=u /opt/indy-scheduler-service && \
    chgrp -R 0 /opt/indy-scheduler-service/log && \
    chmod -R g=u /opt/indy-scheduler-service/log && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy 

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
