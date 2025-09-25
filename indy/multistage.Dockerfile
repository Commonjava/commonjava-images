FROM quay.io/factory2/spmm-pipeline-base:latest AS builder

RUN mkdir indy && \
    cd indy && \
    git init && \
    git remote add origin "$GIT_URL" && \
    git fetch --depth 1 origin "$GIT_REVISION" && \
    git checkout FETCH_HEAD

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV JAVA_11_HOME /usr/lib/jvm/java-11-openjdk
ENV SKIP_NPM_CONFIG false

RUN cd indy && \
    mvn -B -V -gt toolchains.xml clean verify -DskipNpmConfig=false


FROM quay.io/factory2/nos-java-base:latest

ENV INDY_ETC_DIR /usr/share/indy/etc

EXPOSE 8080 8081 8000

USER root

COPY start-indy.py /usr/local/bin/start-indy.py
COPY setup-user.sh /usr/local/bin/setup-user.sh
COPY setup-user.sh /etc/profile.d/setup-user.sh
COPY passwd.template /opt/passwd.template

COPY --from=builder /indy/deployments/launcher/target/*-skinny.tar.gz /tmp/indy-launcher.tar.gz
RUN	tar -xf /tmp/indy-launcher.tar.gz -C /opt

COPY --from=builder /indy/deployments/launcher/target/*-data.tar.gz /tmp/indy-launcher-data.tar.gz
RUN	mkdir -p /usr/share/indy /home/indy && \
	tar -xf /tmp/indy-launcher-data.tar.gz -C /usr/share/indy
	# mkdir -p /opt/indy/var/lib/indy/data/promote && \
	# cp -rf /usr/share/indy/data/promote/rules /opt/indy/var/lib/indy/data/promote/rules

RUN chmod +x /usr/local/bin/*

# Openshift and dynamic user id. https://access.redhat.com/articles/4859371 integration
# enabled by configuring Bourne shell user profile to call setup-user.sh script.
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "source /usr/local/bin/setup-user.sh && /usr/local/bin/start-indy.py"]

RUN mkdir -p /etc/indy && mkdir -p /var/log/indy && mkdir -p /usr/share/indy /opt/indy/var/log/indy
RUN chmod -R 777 /etc/indy && chmod -R 777 /var/log/indy && chmod -R 777 /usr/share/indy
RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    yum install -y java-11-openjdk-devel.x86_64 gettext unzip && yum clean all
RUN cp -rf /opt/indy/var/lib/indy/ui /usr/share/indy/ui
# hadolint ignore=SC2035
RUN yum clean all && rm -rf /var/cache/yum /tmp/yum.log /tmp/RPM-GPG-KEY-CentOS-7 && \
    wget --quiet -O /tmp/byteman.zip https://downloads.jboss.org/byteman/4.0.14/byteman-download-4.0.14-bin.zip && \
    unzip -d /tmp/ /tmp/byteman.zip **/byteman.jar && \
    mv /tmp/byteman-download-4.0.14/lib/byteman.jar /opt/indy/lib/thirdparty && \
    rm -Rf /tmp/byteman.zip

COPY lowOverhead.jfc /usr/share/indy/flightrecorder.jfc
COPY SetStatement300SecondTimeout.btm /usr/share/indy/

# NCL-4814: set umask to 002 so that group permission is 'rwx'
# It works because in start-indy.py we invoke indy.sh with bash -l (login shell)
# that reads from /etc/profile
RUN echo "umask 002" >> /etc/profile

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /etc/indy && \
    chmod -R g=u /etc/indy && \
    chgrp -R 0 /var/log/indy && \
    chmod -R g=u /var/log/indy && \
    chgrp -R 0 /usr/share/indy && \
    chmod -R g=u /usr/share/indy && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy && \
    chmod 644 /etc/profile.d/setup-user.sh

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy
