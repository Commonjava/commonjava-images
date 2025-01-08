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

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/pathmap-storage-service/log /home/indy && \
  chmod -R 777 /opt/pathmap-storage-service && \
  chmod -R 777 /opt/pathmap-storage-service/log

RUN echo "Pulling jar from: $tarball_url"
COPY --from=builder /repo/target/*-runner.jar /opt/pathmap-storage-service/pathmap-storage-service-runner.jar
RUN chmod +r /opt/pathmap-storage-service/pathmap-storage-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/pathmap-storage-service && \
    chmod -R g=u /opt/pathmap-storage-service && \
    chgrp -R 0 /opt/pathmap-storage-service/log && \
    chmod -R g=u /opt/pathmap-storage-service/log && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy

ENTRYPOINT ["bash", "-c"]
CMD ["/usr/local/bin/start-service.sh"]
