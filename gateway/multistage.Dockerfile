FROM quay.io/factory2/spmm-pipeline-base:latest AS builder

RUN mkdir repo && \
    cd repo && \
    git init && \
    git remote add origin $GIT_URL && \
    git fetch --depth 1 origin $GIT_REVISION && \
    git checkout FETCH_HEAD

RUN cd repo && \
    mvn package -Dquarkus.package.type=uber-jar


FROM quay.io/factory2/nos-java-base:latest

USER root

RUN mkdir -p /deployment/log && \
  chmod -R 777 /deployment/log

RUN echo "Pulling jar from: $tarball_url"
COPY --from=builder /repo/target/*-runner.jar /deployment/gateway-runner.jar
RUN chmod +r /deployment/gateway-runner.jar

ADD start-gateway.sh /deployment/start-gateway.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["bash", "-c"]
CMD ["/deployment/start-gateway.sh"]
