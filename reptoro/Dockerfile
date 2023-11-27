FROM quay.io/factory2/nos-java-base:latest

#ARG tarball_url=https://some.host/some/path/to/reptoro.jar
ARG jar_url

ENV JAVA_APP_DIR=/deployments
ENV JAVA_OPTIONS -Dvertx.cacheDirBase=/tmp \
	-Dvertx.disableDnsResolver=true \
	-Dvertx.metrics.options.enabled=true \
	-Dvertx.metrics.options.jmxEnabled=true \
	-Dvertx.metrics.options.jmxDomain=vertx

EXPOSE 8080 8778 9779

USER root

RUN mkdir -p /deployment/resources

COPY ${jar_url} /deployment

USER 1001
