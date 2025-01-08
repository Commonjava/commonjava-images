FROM quay.io/factory2/nos-java-base:ubi9

EXPOSE 8080

USER root

COPY start-service.sh /usr/local/bin/start-service.sh

RUN chmod +x /usr/local/bin/*

RUN mkdir -p /opt/pathmap-storage-service/log /home/indy && \
  chmod -R 777 /opt/pathmap-storage-service && \
  chmod -R 777 /opt/pathmap-storage-service/log

COPY pathmap-storage-service-runner.jar /opt/pathmap-storage-service/pathmap-storage-service-runner.jar
RUN chmod +r /opt/pathmap-storage-service/pathmap-storage-service-runner.jar

# Run as non-root user
RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt && \
    chgrp -R 0 /opt/pathmap-storage-service && \
    chmod -R g=u /opt/pathmap-storage-service && \
    chgrp -R 0 /opt/pathmap-storage-service/log && \
    chmod -R g=u /opt/pathmap-storage-service/log

USER 1001

ENTRYPOINT ["bash", "-c"]
CMD ["/usr/local/bin/start-service.sh"]
