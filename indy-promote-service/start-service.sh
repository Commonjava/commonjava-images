#!/bin/sh

echo "Promote Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-promote-service
$JAVA_CMD $JAVA_OPTS -jar ./indy-promote-service-runner.jar
