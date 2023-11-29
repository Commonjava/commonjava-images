FROM quay.io/factory2/nos-java-base:latest

ARG jar_ur

ENV JAVA_APP_DIR=/deployments
ENV JAVA_OPTIONS -Dvertx.cacheDirBase=/tmp \
	-Dvertx.disableDnsResolver=true \
	-Dvertx.metrics.options.enabled=true \
	-Dvertx.metrics.options.jmxEnabled=true \
	-Dvertx.metrics.options.jmxDomain=vertx

EXPOSE 8080 8778 9779

USER root

RUN mkdir -p /deployment/resources

ADD ${jar_url} /deployment/app.jar

USER 1001
