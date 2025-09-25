FROM quay.io/factory2/nos-java-base:jdk11

USER root

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment/log

COPY gateway-runner.jar /deployment/gateway-runner.jar
RUN chmod +r /deployment/gateway-runner.jar

COPY start-gateway.sh /deployment/start-gateway.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-gateway.sh"]
