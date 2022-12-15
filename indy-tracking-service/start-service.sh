#!/bin/sh

echo "Indy Tracking Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-tracking-service/
$JAVA_CMD $JAVA_OPTS -jar ./indy-tracking-service-runner.jar
