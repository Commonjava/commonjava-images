FROM quay.io/factory2/nos-java-base:ubi9

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-sidecar/log && \
  chmod -R 777 /opt/indy-sidecar && \
  chmod -R 777 /opt/indy-sidecar/log

RUN echo "Pulling jar from: $tarball_url"
ADD $tarball_url /opt/indy-sidecar/indy-sidecar-runner.jar
RUN chmod +r /opt/indy-sidecar/indy-sidecar-runner.jar

RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-sidecar && \
    chmod -R g=u /opt/indy-sidecar && \
    chgrp -R 0 /opt/indy-sidecar/log && \
    chmod -R g=u /opt/indy-sidecar/log

USER 1001

ENTRYPOINT ["bash", "-c"]
CMD ["/usr/local/bin/start-service.sh"]
