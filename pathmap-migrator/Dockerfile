FROM quay.io/factory2/nos-java-base:latest

ENV JAVA_APP_DIR=/deployments

USER root

RUN echo "Pulling jar from: $jar_url" && \
	curl -SsLo /deployment/pathmap-migrator.jar $jar_url

USER 1001
