FROM quay.io/factory2/nos-java-base:latest

ENV JAVA_APP_DIR=/deployments
ENV JAVA_OPTIONS -Dvertx.cacheDirBase=/tmp \
	-Dvertx.disableDnsResolver=true \
	-Dvertx.metrics.options.enabled=true \
	-Dvertx.metrics.options.jmxEnabled=true \
	-Dvertx.metrics.options.jmxDomain=vertx

EXPOSE 8080 8778 9779

USER root

RUN mkdir -p /deployment/resources

RUN mkdir -p /deployment/resources && \
	echo "Pulling jar from: $jar_url" && \
	curl -SsLo /deployment/app.jar "$jar_url"

USER 1001
