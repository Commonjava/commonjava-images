#!/bin/sh

echo "Indy Repository Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-repository-service/
$JAVA_CMD $JAVA_OPTS -jar ./indy-repository-service-runner.jar