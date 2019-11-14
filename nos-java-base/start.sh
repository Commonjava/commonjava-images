#!/bin/bash

source /etc/profile

set -x

if [ -d /deployment/scripts ]; then
    for script in $(ls -1 /deployment/scripts/*.sh); do
        exec $script
    done
fi

JAVA=$(which java)
$JAVA -version 2>&1 > /dev/null
if [ $? != 0 ]; then
  PATH=${JAVA_HOME}/bin:${PATH}
  JAVA=${JAVA_HOME}/bin/java
fi

CP=""
if [ -d /deployment/resources ]; then
    CP="-cp /deployment/resources"
fi

exec $JAVA $JAVA_OPTS $CP -jar /deployment/app.jar "$@"
