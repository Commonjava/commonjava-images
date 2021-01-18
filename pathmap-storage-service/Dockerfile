FROM quay.io/factory2/nos-java-base:latest

USER root

RUN yum -y install java-11-openjdk-devel

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment/log && \
  echo "Pulling jar from: $tarball_url" && \
  wget $tarball_url -O /deployment/pathmap-storage-service-runner.jar

ADD start.sh /deployment/start.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start.sh"]
