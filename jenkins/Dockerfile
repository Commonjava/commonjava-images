# Uncomment this for community builds
FROM quay.io/openshift/origin-jenkins
# FROM openshift/jenkins-2-centos7

LABEL Name="nos-jenkins" \
    Version="1" \
    Release="1"

#USER root

#ENV TZ UTC

# Additional plugins. You can set JENKINS_UC to change the default URL to Jenkins update center.
# The format of 'plugins.txt. is:
#
# pluginId:pluginVersion

COPY plugins.txt /opt/openshift/plugins.txt
RUN /usr/local/bin/install-plugins.sh /opt/openshift/plugins.txt