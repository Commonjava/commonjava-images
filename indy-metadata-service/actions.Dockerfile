FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment && \
  chmod -R 777 /deployment/log

COPY indy-metadata-service-runner.jar /deployment/indy-metadata-service-runner.jar
RUN chmod +r /deployment/indy-metadata-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /deployment && \
    chmod -R g=u /deployment && \
    chgrp -R 0 /deployment/log && \
    chmod -R g=u /deployment/log

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
