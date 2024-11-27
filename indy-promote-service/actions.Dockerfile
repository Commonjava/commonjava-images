FROM quay.io/factory2/nos-java-base:latest

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-promote-service/log /home/indy && \
  chmod -R 777 /opt/indy-promote-service && \
  chmod -R 777 /opt/indy-promote-service/log

ADD indy-promote-service-runner.jar /opt/indy-promote-service/indy-promote-service-runner.jar
RUN chmod +r /opt/indy-promote-service/indy-promote-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-promote-service && \
    chmod -R g=u /opt/indy-promote-service && \
    chgrp -R 0 /opt/indy-promote-service/log && \
    chmod -R g=u /opt/indy-promote-service/log

USER 1001

ENTRYPOINT ["bash", "-c"]
CMD ["/usr/local/bin/start-service.sh"]
