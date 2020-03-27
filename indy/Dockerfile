FROM quay.io/factory2/nos-java-base:latest

ENV INDY_ETC_DIR /usr/share/indy/etc
ENV JDK_8_DIR /opt/shipilev-openjdk8-dev
ENV JDK_8_SHIPILEV_DOWNLOAD_URL https://builds.shipilev.net/openjdk-jdk8-dev/
ENV JDK_8_SHIPILEV_DOWNLOAD_FILE openjdk-jdk8-dev-latest-linux-x86_64-release.tar.xz

EXPOSE 8080 8081 8000

USER root

ADD start-indy.py /usr/local/bin/start-indy.py

ARG tarball_url

ADD $tarball_url /opt

ARG data_tarball_url
ADD $data_tarball_url /usr/share/indy
RUN mkdir -p /opt/indy/var/lib/indy/data/promote && \
	cp -rf /usr/share/indy/data/promote/rules /opt/indy/var/lib/indy/data/promote/rules

RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/start-indy.py"]

RUN mkdir -p /etc/indy && mkdir -p /var/log/indy && mkdir -p /usr/share/indy
RUN chmod -R 777 /etc/indy && chmod -R 777 /var/log/indy && chmod -R 777 /usr/share/indy
RUN cp -rf /opt/indy/var/lib/indy/ui /usr/share/indy/ui
RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless &&  \
    wget -P /tmp http://mirror.centos.org/centos/7.7.1908/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo=http://mirror.centos.org/centos/7.7.1908/os/x86_64/ && \
    yum update -y --security && \
    yum clean all && \
    mkdir -p "$JDK_8_DIR" && \
    wget -P "$JDK_8_DIR" "$JDK_8_SHIPILEV_DOWNLOAD_URL$JDK_8_SHIPILEV_DOWNLOAD_FILE" && \
    tar -xf "$JDK_8_DIR/$JDK_8_SHIPILEV_DOWNLOAD_FILE" -C "$JDK_8_DIR" && \
    rm "$JDK_8_DIR/$JDK_8_SHIPILEV_DOWNLOAD_FILE"

RUN alternatives --install /usr/bin/java java \
    "$JDK_8_DIR/j2sdk-image/bin/java" 9999999 --slave /usr/bin/jcmd jcmd \
    "$JDK_8_DIR/j2sdk-image/bin/jcmd" --slave /usr/bin/jps jps \
    "$JDK_8_DIR/j2sdk-image/bin/jps" --slave /usr/bin/jstack jstack \
    "$JDK_8_DIR/j2sdk-image/bin/jstack" --slave /usr/bin/jar jar \
    "$JDK_8_DIR/j2sdk-image/bin/jar" --slave /usr/bin/jinfo jinfo \
    "$JDK_8_DIR/j2sdk-image/bin/jinfo" --slave /usr/bin/jstat jstat \
    "$JDK_8_DIR/j2sdk-image/bin/jstat" --slave /usr/bin/jarsigner jarsigner \
    "$JDK_8_DIR/j2sdk-image/bin/jarsigner" --slave /usr/bin/jconsole jconsole \
    "$JDK_8_DIR/j2sdk-image/bin/jconsole" --slave /usr/bin/jdb jdb \
    "$JDK_8_DIR/j2sdk-image/bin/jdb" --slave /usr/bin/jdeprscan jdeprscan \
    "$JDK_8_DIR/j2sdk-image/bin/jdeprscan" --slave /usr/bin/jdeps jdeps \
    "$JDK_8_DIR/j2sdk-image/bin/jdeps" --slave /usr/bin/jfr jfr \
    "$JDK_8_DIR/j2sdk-image/bin/jfr" --slave /usr/bin/jlink jlink \
    "$JDK_8_DIR/j2sdk-image/bin/jlink" --slave /usr/bin/jmap jmap \
    "$JDK_8_DIR/j2sdk-image/bin/jmap" --slave /usr/bin/jrunscript jrunscript \
    "$JDK_8_DIR/j2sdk-image/bin/jrunscript" --slave /usr/bin/jshell jshell \
    "$JDK_8_DIR/j2sdk-image/bin/jshell" --slave /usr/bin/jstatd jstatd \
    "$JDK_8_DIR/j2sdk-image/bin/jstatd" --slave /usr/bin/keytool keytool \
    "$JDK_8_DIR/j2sdk-image/bin/keytool" --slave /usr/bin/pack200 pack200 \
    "$JDK_8_DIR/j2sdk-image/bin/pack200" --slave /usr/bin/rmiregistry rmiregistry \
    "$JDK_8_DIR/j2sdk-image/bin/rmiregistry" && alternatives --auto java

ADD lowOverhead.jfc /usr/share/indy/flightrecorder.jfc

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
    chgrp -R 0 "$JDK_8_DIR" && \
    chmod -R g=u "$JDK_8_DIR"

USER 1001
