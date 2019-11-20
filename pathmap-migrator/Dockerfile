FROM quay.io/factory2/nos-java-base:latest

USER root

RUN mkdir -p /deployment && \
  echo "Pulling jar from: $jar_url" && \
  curl -SsLo /deployment/pathmap-migrator.jar $jar_url

USER 1001
