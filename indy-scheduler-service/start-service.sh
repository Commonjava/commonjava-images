#!/bin/sh

echo "Indy Scheduler Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-scheduler-service/
$JAVA_CMD $JAVA_OPTS -jar ./indy-scheduler-service-runner.jar