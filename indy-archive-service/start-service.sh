#!/bin/sh

echo "Indy Archive Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-archive-service/
$JAVA_CMD $JAVA_OPTS -jar ./indy-archive-service-runner.jar
