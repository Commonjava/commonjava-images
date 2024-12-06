#FROM quay.io/factory2/nos-java-base:ubi9-minimal
FROM registry.access.redhat.com/ubi9/openjdk-11-runtime:1.21-1

USER root

ADD 2022-IT-Root-CA.pem /etc/pki/ca-trust/source/anchors/2022-IT-Root-CA.pem
RUN update-ca-trust extract

RUN mkdir -p /deployment/log /deployment/config && \
  chmod -R 777 /deployment/log /deployment/config
  
RUN echo "Pulling jar from: $tarball_url"
ADD $tarball_url /deployment/indy-generic-proxy-service-runner.jar
RUN chmod +r /deployment/indy-generic-proxy-service-runner.jar

ADD start-service.sh /deployment/start-service.sh
RUN chmod +x /deployment/*

USER 1001

WORKDIR /

ENTRYPOINT ["bash", "-c"]
CMD ["/deployment/start-service.sh"]
