#!/bin/bash
# configure dynamic user for containers in Openshift 
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /opt/passwd.template > /tmp/passwd
export LD_PRELOAD=/usr/lib64/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
cp /tmp/passwd /etc/passwd
