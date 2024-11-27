FROM quay.io/factory2/nos-java-base:latest

USER root

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment/log

ADD gateway-runner.jar /deployment/gateway-runner.jar
RUN chmod +r /deployment/gateway-runner.jar

ADD start-gateway.sh /deployment/start-gateway.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["bash", "-c"]
CMD ["/deployment/start-gateway.sh"]