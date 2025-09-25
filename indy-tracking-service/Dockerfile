FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-tracking-service/log && \
  chmod -R 777 /opt/indy-tracking-service && \
  chmod -R 777 /opt/indy-tracking-service/log

RUN echo "Pulling jar from: $tarball_url"
# hadolint ignore=DL3020
ADD $tarball_url /opt/indy-tracking-service/indy-tracking-service-runner.jar
RUN chmod +r /opt/indy-tracking-service/indy-tracking-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-tracking-service && \
    chmod -R g=u /opt/indy-tracking-service && \
    chgrp -R 0 /opt/indy-tracking-service/log && \
    chmod -R g=u /opt/indy-tracking-service/log 

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
