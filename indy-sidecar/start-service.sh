#!/bin/sh

echo "Indy Sidecar Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-sidecar/
$JAVA_CMD $JAVA_OPTS -jar ./indy-sidecar-runner.jar
