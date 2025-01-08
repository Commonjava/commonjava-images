FROM quay.io/factory2/spmm-pipeline-base:latest AS builder

RUN mkdir repo && \
    cd repo && \
    git init && \
    git remote add origin $GIT_URL && \
    git fetch --depth 1 origin $GIT_REVISION && \
    git checkout FETCH_HEAD

RUN cd repo && \
    mvn package -Dquarkus.package.type=uber-jar


FROM quay.io/factory2/nos-java-base:ubi9

USER root

RUN mkdir -p /deployment/log /deployment/config && \
  chmod -R 777 /deployment/log /deployment/config
  
RUN echo "Pulling jar from: $tarball_url"
COPY --from=builder /repo/target/*-runner.jar /deployment/indy-generic-proxy-service-runner.jar
RUN chmod +r /deployment/indy-generic-proxy-service-runner.jar

ADD start-service.sh /deployment/start-service.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["bash", "-c"]
CMD ["/deployment/start-service.sh"]
