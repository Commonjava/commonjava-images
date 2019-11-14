FROM fabric8/java-centos-openjdk8-jdk:1.5

#ARG tarball_url=https://some.host/some/path/to/reptoro.jar


ENV JAVA_APP_DIR=/deployments
ENV JAVA_OPTIONS -Dvertx.cacheDirBase=/tmp \
	-Dvertx.disableDnsResolver=true \
	-Dvertx.metrics.options.enabled=true \
	-Dvertx.metrics.options.jmxEnabled=true \
	-Dvertx.metrics.options.jmxDomain=vertx

EXPOSE 8080 8778 9779

#COPY maven /deployments/

RUN curl -SsLo /deployments/reptoro.jar $tarball_url

