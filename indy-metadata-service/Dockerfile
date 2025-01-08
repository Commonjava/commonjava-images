FROM quay.io/factory2/nos-java-base:ubi9

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /deployment/log /deployment/config && \
  chmod -R 777 /deployment && \
  chmod -R 777 /deployment/log /deployment/config

RUN echo "Pulling jar from: $tarball_url"
ADD $tarball_url /deployment/indy-metadata-service-runner.jar
RUN chmod +r /deployment/indy-metadata-service-runner.jar

ADD start-service.sh /deployment/start-service.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["bash", "-c"]
CMD ["/deployment/start-service.sh"]
