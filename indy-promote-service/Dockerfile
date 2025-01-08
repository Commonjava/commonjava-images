FROM quay.io/factory2/nos-java-base:ubi9

EXPOSE 8080

USER root

ADD start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/indy-promote-service/log /home/indy && \
  chmod -R 777 /opt/indy-promote-service && \
  chmod -R 777 /opt/indy-promote-service/log

RUN echo "Pulling jar from: $tarball_url"
ADD $tarball_url /opt/indy-promote-service/indy-promote-service-runner.jar
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

ENTRYPOINT ["bash", "-c"]
CMD ["/usr/local/bin/start-service.sh"]
