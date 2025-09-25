FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /deployment/log /deployment/config && \
  chmod -R 777 /deployment/log /deployment/config
  
COPY indy-generic-proxy-service-runner.jar /deployment/indy-generic-proxy-service-runner.jar
RUN chmod +r /deployment/indy-generic-proxy-service-runner.jar

COPY start-service.sh /deployment/start-service.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-service.sh"]
