#!/bin/sh

echo "Hello! Indy metadata service starts!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /deployment
$JAVA_CMD $JAVA_OPTS -jar ./indy-metadata-service-runner.jar