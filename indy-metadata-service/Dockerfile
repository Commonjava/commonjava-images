FROM quay.io/factory2/nos-java-base:latest

USER root

ADD setup-user.sh /usr/local/bin/setup-user.sh
ADD setup-user.sh /etc/profile.d/setup-user.sh
ADD passwd.template /opt/passwd.template

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN yum -y install java-11-openjdk-devel

RUN mkdir -p /opt/indy-metadata-service/log /home/indy && \
  chmod -R 777 /opt/indy-metadata-service && \
  chmod -R 777 /opt/indy-metadata-service/log && \
  echo "Pulling jar from: $tarball_url" && \
  wget $tarball_url -O /opt/indy-metadata-service/indy-metadata-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/indy-metadata-service && \
    chmod -R g=u /opt/indy-metadata-service && \
    chgrp -R 0 /opt/indy-metadata-service/log && \
    chmod -R g=u /opt/indy-metadata-service/log && \
    chgrp -R 0 /home/indy && \
    chmod -R g=u /home/indy && \
    chown -R 1001:0 /home/indy && \
    chmod 644 /etc/profile.d/setup-user.sh

USER 1001

ENV LOGNAME=indy
ENV USER=indy
ENV HOME=/home/indy

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bash", "-c", "source /usr/local/bin/setup-user.sh && /usr/local/bin/start-service.sh"]
