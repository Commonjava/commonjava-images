# Maven 3.6 Jenkins agent

Commonjava/gateway needs maven 3.6.2+ and there is no such image on the world as of today. We have to craft one from the maven-35 base.

## Steps

oc create -f create-is.yaml 
oc create -f create-bc.yaml
oc start-build jenkins-agent-maven-36-rhel7 -n nos-automation --follow 
