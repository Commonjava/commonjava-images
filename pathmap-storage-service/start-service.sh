#!/bin/sh

echo "Indy PathMap Storage Service Started!"

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export JAVA_CMD=$JAVA_HOME/bin/java

cd /opt/pathmap-storage-service/
$JAVA_CMD $JAVA_OPTS -Dcom.datastax.driver.FORCE_NIO=true  -jar ./pathmap-storage-service-runner.jar
