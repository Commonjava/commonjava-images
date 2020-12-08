#!/bin/bash

source /etc/profile

# set -x
if [ ! -f "/tmp/app.jar" ]; then
	if [ "x${URL}" == "x" ]; then
		echo "missing \$URL binary environment variable."
		exit 1
	fi

	curl --output /tmp/app.jar $URL
	if [ $? != 0 ]; then
		echo "Cannot download binary from $URL"
		exit 2
	fi
fi

JAVA=$(which java)
$JAVA -version 2>&1 > /dev/null
if [ $? != 0 ]; then
  PATH=${JAVA_HOME}/bin:${PATH}
  JAVA=${JAVA_HOME}/bin/java
fi

$JAVA $JAVA_OPTS -jar /tmp/app.jar "$ARGS"
rt=$?

echo "Command exited with value '$rt'. Entering infinite loop, awaiting pod termination."
# set +x
while true
do
	sleep 1
done
