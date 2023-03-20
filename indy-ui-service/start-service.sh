#!/bin/sh

echo "Indy UI Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-ui-service/
$JAVA_CMD $JAVA_OPTS -jar ./indy-ui-service-runner.jar