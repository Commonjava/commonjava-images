FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-sidecar/log && \
  chmod -R 777 /opt/indy-sidecar && \
  chmod -R 777 /opt/indy-sidecar/log

COPY indy-sidecar-runner.jar /opt/indy-sidecar/indy-sidecar-runner.jar
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
