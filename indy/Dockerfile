FROM quay.io/factory2/nos-java-base:latest

USER root

ARG tarball_url
ARG data_tarball_url

ADD ${tarball_url} /tmp/indy-launcher.tar.gz
ADD ${data_tarball_url} /tmp/indy-launcher-data.tar.gz
RUN	mkdir -p /usr/share/indy /home/indy && \
    mkdir -p /etc/indy && \
    mkdir -p /var/log/indy && \
    mkdir -p /usr/share/indy /opt/indy/var/log/indy && \
    tar -xf /tmp/indy-launcher.tar.gz -C /opt && \
	tar -xf /tmp/indy-launcher-data.tar.gz -C /usr/share/indy

ADD start-indy.py /usr/local/bin/start-indy.py
ADD https://downloads.jboss.org/byteman/4.0.23/byteman-download-4.0.23-bin.zip /tmp/byteman.zip
ADD lowOverhead.jfc /usr/share/indy/flightrecorder.jfc
ADD SetStatement300SecondTimeout.btm /usr/share/indy/

RUN chmod +x /usr/local/bin/* && \
    chmod -R 777 /etc/indy && \
    chmod -R 777 /var/log/indy && \
    chmod -R 777 /usr/share/indy

RUN cp -rf /opt/indy/var/lib/indy/ui /usr/share/indy/ui
RUN dnf install -y gettext unzip && \
    unzip -d /tmp/ /tmp/byteman.zip **/byteman.jar && \
    mv /tmp/byteman-download-4.0.23/lib/byteman.jar /opt/indy/lib/thirdparty && \
    rm -rf /var/cache/yum

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
    chown -R 1001:0 /home/indy

EXPOSE 8080 8081 8000

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy
ENV INDY_ETC_DIR /usr/share/indy/etc

ENTRYPOINT ["bash", "-c"]
CMD ["/usr/local/bin/start-indy.py"]
