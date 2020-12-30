FROM quay.io/factory2/nos-java-base:latest

USER root

ADD hold-main.sh /usr/local/bin/hold.sh

RUN chmod +x /usr/local/bin/hold.sh

RUN mkdir -p /deployment && \
  echo "Pulling jar from: $jar_url" && \
  curl -SsLo /deployment/pathmap-migrator.jar $jar_url

ADD run-scan.sh.sample /deployment/run-scan.sh.sample
ADD run-migrate.sh.sample /deployment/run-migrate.sh.sample

USER 1001

ENTRYPOINT ["/usr/local/bin/dumb-init", "/usr/local/bin/hold.sh"]
