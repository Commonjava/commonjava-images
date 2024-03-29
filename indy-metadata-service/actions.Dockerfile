FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-metadata-service/log && \
  chmod -R 777 /opt/indy-metadata-service && \
  chmod -R 777 /opt/indy-metadata-service/log

ADD indy-metadata-service-runner.jar /opt/indy-metadata-service/indy-metadata-service-runner.jar
RUN chmod +r /opt/indy-metadata-service/indy-metadata-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-metadata-service && \
    chmod -R g=u /opt/indy-metadata-service && \
    chgrp -R 0 /opt/indy-metadata-service/log && \
    chmod -R g=u /opt/indy-metadata-service/log

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
