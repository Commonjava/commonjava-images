##############################################
# Stage 1 : Build go-init
##############################################
# hadolint ignore=DL3026
FROM openshift/origin-release:golang-1.12 AS go-init-builder
WORKDIR  /go/src/github.com/openshift/jenkins
COPY . .
WORKDIR  /go/src/github.com/openshift/jenkins/go-init
RUN go build . && cp go-init /usr/bin

##############################################
# Stage 2 : Build slave-base with go-init
##############################################
FROM quay.io/openshift/origin-cli:4.2
COPY --from=go-init-builder /usr/bin/go-init /usr/bin/go-init

ENV HOME=/home/jenkins \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# hadolint ignore=DL3002
USER root
# Install headless Java
COPY contrib/openshift/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD  http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN  chmod +r /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN INSTALL_PKGS="bc gettext git java-11-openjdk-headless java-1.8.0-openjdk-headless lsof rsync tar unzip which zip bzip2 jq curl tree gcc make net-tools iotop golang" && \
    DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \
    yum "$DISABLES" install -y --setopt=tsflags=nodocs --disableplugin=subscription-manager epel-release && \
    yum "$DISABLES" install -y --setopt=tsflags=nodocs --disableplugin=subscription-manager "$INSTALL_PKGS" && \
    rpm -V  "$INSTALL_PKGS" && \
    yum clean all && \
    mkdir -p /home/jenkins && \
    chown -R 1001:0 /home/jenkins && \
    chmod -R g+w /home/jenkins && \
    chmod -R 775 /etc/alternatives && \
    chmod -R 775 /var/lib/alternatives && \
    chmod -R 775 /usr/lib/jvm && \
    chmod 775 /usr/bin && \
    chmod 775 /usr/share/man/man1 && \
    mkdir -p /var/lib/origin && \
    chmod 775 /var/lib/origin && \    
    unlink /usr/bin/java && \
    unlink /usr/bin/jjs && \
    unlink /usr/bin/keytool && \
    unlink /usr/bin/pack200 && \
    unlink /usr/bin/rmid && \
    unlink /usr/bin/rmiregistry && \
    unlink /usr/bin/unpack200 && \
    unlink /usr/share/man/man1/java.1.gz && \
    unlink /usr/share/man/man1/jjs.1.gz && \
    unlink /usr/share/man/man1/keytool.1.gz && \
    unlink /usr/share/man/man1/pack200.1.gz && \
    unlink /usr/share/man/man1/rmid.1.gz && \
    unlink /usr/share/man/man1/rmiregistry.1.gz && \
    unlink /usr/share/man/man1/unpack200.1.gz

# Copy the entrypoint
COPY contrib/bin/* /usr/local/bin/

ENV BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 

COPY cacerts/RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
COPY cacerts/2022-IT-Root-CA.pem /etc/pki/ca-trust/source/anchors/2022-IT-Root-CA.pem
RUN update-ca-trust extract

RUN mkdir -p $HOME/gopath && \
    chown -R 1001:0 "$HOME" && \
    chown -R 1001:0 "$HOME/gopath" && \
    chmod -R g+rw "$HOME" && \
    chmod -R g+rw "$HOME/gopath"
ENV GOPATH="$HOME/gopath"

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/bin/go-init", "-main", "/usr/local/bin/run-jnlp-client"]

##############################################
# End
##############################################
