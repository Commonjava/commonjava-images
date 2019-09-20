# Commonjava Service Image Definitions

These are images for use in Kubernetes. They include services that we support (the Indy service suite) and services we use in our development process.

## Indy

This is the image for the current Indy monolith service. Eventually, this will be reduced to the core functions, and we'll have other services. For now, this is it. We'll include SSL certs needed for running in our internal environment, and JVM profiling / flight-recorder configs to help us gather evidence for production support issues.

## Jenkins

This Jenkins image is an extension of the one that ships with Openshift, so we can do things like specify the timezone and add plugins.

