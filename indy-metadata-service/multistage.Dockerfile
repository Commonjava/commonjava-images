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

USER root

COPY setup-user.sh /usr/local/bin/setup-user.sh
COPY setup-user.sh /etc/profile.d/setup-user.sh
COPY passwd.template /opt/passwd.template

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

#RUN yum -y install java-11-openjdk-devel
RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -q -P /tmp http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7/os/x86_64/ && \
    yum -y install java-11-openjdk-devel.x86_64 && yum clean all

RUN mkdir -p /deployment/log /deployment/config && \
  chmod -R 777 /deployment && \
  chmod -R 777 /deployment/log /deployment/config

RUN echo "Pulling jar from: $tarball_url"
COPY --from=builder /repo/target/*-runner.jar /deployment/indy-metadata-service-runner.jar
RUN chmod +r /deployment/indy-metadata-service-runner.jar

COPY start-service.sh /deployment/start-service.sh
RUN chmod +x /deployment/*

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/deployment/start-service.sh"]
