FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-ui-service/log && \
  chmod -R 777 /opt/indy-ui-service && \
  chmod -R 777 /opt/indy-ui-service/log

COPY indy-ui-service-runner.jar /opt/indy-ui-service/indy-ui-service-runner.jar
RUN chmod +r /opt/indy-ui-service/indy-ui-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-ui-service && \
    chmod -R g=u /opt/indy-ui-service && \
    chgrp -R 0 /opt/indy-ui-service/log && \
    chmod -R g=u /opt/indy-ui-service/log 

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
