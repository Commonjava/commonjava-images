FROM quay.io/factory2/spmm-pipeline-base:latest AS builder

RUN mkdir repo && \
    cd repo && \
    git init && \
    git remote add origin "$GIT_URL" && \
    git fetch --depth 1 origin "$GIT_REVISION" && \
    git checkout FETCH_HEAD

RUN cd repo && \
    mvn package -Dquarkus.package.type=uber-jar


FROM quay.io/factory2/nos-java-base:jdk11

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-ui-service/log && \
  chmod -R 777 /opt/indy-ui-service && \
  chmod -R 777 /opt/indy-ui-service/log

RUN echo "Pulling jar from: $tarball_url"
COPY --from=builder /repo/target/*-runner.jar /opt/indy-ui-service/indy-ui-service-runner.jar
RUN chmod +r /opt/indy-ui-service/indy-ui-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-ui-service && \
    chmod -R g=u /opt/indy-ui-service && \
    chgrp -R 0 /opt/indy-ui-service/log && \
    chmod -R g=u /opt/indy-ui-service/log 

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
