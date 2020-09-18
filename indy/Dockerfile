FROM quay.io/factory2/nos-java-base:latest

ENV INDY_ETC_DIR /usr/share/indy/etc

EXPOSE 8080 8081 8000

USER root

ADD start-indy.py /usr/local/bin/start-indy.py

ADD $tarball_url /tmp/indy-launcher.tar.gz
RUN	tar -zxf /tmp/indy-launcher.tar.gz -C /opt

ADD $data_tarball_url /tmp/indy-launcher-data.tar.gz
RUN	mkdir -p /usr/share/indy && \
	tar -zxf /tmp/indy-launcher-data.tar.gz -C /usr/share/indy && \
	mkdir -p /opt/indy/var/lib/indy/data/promote && \
	cp -rf /usr/share/indy/data/promote/rules /opt/indy/var/lib/indy/data/promote/rules

RUN chmod +x /usr/local/bin/*

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/start-indy.py"]

RUN mkdir -p /etc/indy && mkdir -p /var/log/indy && mkdir -p /usr/share/indy /opt/indy/var/log/indy
RUN chmod -R 777 /etc/indy && chmod -R 777 /var/log/indy && chmod -R 777 /usr/share/indy
RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    wget -P /tmp http://mirror.centos.org/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7 && \
    rpm --import /tmp/RPM-GPG-KEY-CentOS-7 && \
    yum-config-manager --add-repo http://mirror.centos.org/centos/7/os/x86_64/ && \
    yum install -y java-11-openjdk-devel.x86_64 java-11-openjdk-headless.x86_64 && \
    yum clean all
RUN cp -rf /opt/indy/var/lib/indy/ui /usr/share/indy/ui

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
    chmod -R g=u /usr/share/indy

USER 1001
