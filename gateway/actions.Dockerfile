FROM quay.io/factory2/nos-java-base:jdk11

USER root

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment/log

ADD gateway-runner.jar /deployment/gateway-runner.jar
RUN chmod +r /deployment/gateway-runner.jar

ADD start-gateway.sh /deployment/start-gateway.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-gateway.sh"]
