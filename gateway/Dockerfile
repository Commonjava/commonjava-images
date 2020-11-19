FROM quay.io/factory2/nos-java-base:latest

USER root

RUN yum -y install java-11-openjdk-devel

RUN mkdir -p /deployment && \
  echo "Pulling jar from: $tarball_url" && \
  wget $tarball_url -O /deployment/gateway-runner.jar

ADD start-gateway.sh /deployment/start-gateway.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-gateway.sh"]
