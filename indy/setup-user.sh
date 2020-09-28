#!/bin/bash
echo "Generate passwd file based on dynamic user for containers in Openshift and use NSS_WRAPPER to set it."
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /opt/passwd.template > $HOME/passwd
chmod 744 $HOME/passwd
export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=$HOME/passwd
export NSS_WRAPPER_GROUP=/etc/group
echo "NSS_WRAPPER configured. Now running diagnostic commands to reveal nss_wrapper operating as expected."
echo "id:$(id)"
echo "whoami:$(whoami)"
