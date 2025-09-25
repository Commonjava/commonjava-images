FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-promote-service/log /home/indy && \
  chmod -R 777 /opt/indy-promote-service && \
  chmod -R 777 /opt/indy-promote-service/log

COPY indy-promote-service-runner.jar /opt/indy-promote-service/indy-promote-service-runner.jar
RUN chmod +r /opt/indy-promote-service/indy-promote-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-promote-service && \
    chmod -R g=u /opt/indy-promote-service && \
    chgrp -R 0 /opt/indy-promote-service/log && \
    chmod -R g=u /opt/indy-promote-service/log

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
