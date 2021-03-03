#!/bin/sh

echo "Indy Metadata Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/indy-metadata-service/
$JAVA_CMD $JAVA_OPTS -Dcom.datastax.driver.FORCE_NIO=true  -jar ./indy-metadata-service-runner.jar
