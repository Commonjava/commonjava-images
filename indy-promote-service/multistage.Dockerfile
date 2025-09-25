FROM quay.io/factory2/spmm-pipeline-base:latest AS builder

RUN mkdir repo && \
    cd repo && \
    git init && \
    git remote add origin "$GIT_URL" && \
    git fetch --depth 1 origin "$GIT_REVISION" && \
    git checkout FETCH_HEAD

RUN cd repo && \
    mvn package -Dquarkus.package.type=uber-jar


FROM quay.io/factory2/nos-java-base:latest

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -q -P /tmp http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7/os/x86_64/ && \
    yum install -y java-11-openjdk-devel.x86_64 gettext unzip && yum clean all

RUN mkdir -p /opt/indy-promote-service/log /home/indy && \
  chmod -R 777 /opt/indy-promote-service && \
  chmod -R 777 /opt/indy-promote-service/log

RUN echo "Pulling jar from: $tarball_url"
COPY --from=builder /repo/target/*-runner.jar /opt/indy-promote-service/indy-promote-service-runner.jar
RUN chmod +r /opt/indy-promote-service/indy-promote-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-promote-service && \
    chmod -R g=u /opt/indy-promote-service && \
    chgrp -R 0 /opt/indy-promote-service/log && \
    chmod -R g=u /opt/indy-promote-service/log && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "/usr/local/bin/start-service.sh"]
