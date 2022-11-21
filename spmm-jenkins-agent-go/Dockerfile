FROM quay.io/openshift/origin-jenkins-agent-base:4.10

LABEL maintainer="RedHat EXD SPMM TEAM"

ENV BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 

# Install RH Certificates
ADD Eng_Ops_CA.crt /etc/pki/ca-trust/source/anchors/Eng_Ops_CA.crt
ADD Red_Hat_IS_CA.crt /etc/pki/ca-trust/source/anchors/Red_Hat_IS_CA.crt
ADD RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
RUN update-ca-trust extract

# Install needed packages
COPY repos/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
COPY repos/epel.repo /etc/yum.repos.d/epel.repo

RUN curl http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    INSTALL_PKGS="wget git tar which curl tree gcc make net-tools lsof iotop golang" && \
    DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \
    yum $DISABLES update -y && \
    yum $DISABLES install -y $INSTALL_PKGS && \
    rpm -V golang.x86_64 && \
    yum clean all -y 

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ADD bin/scl_enable /usr/local/bin/scl_enable
ADD bin/configure-agent /usr/local/bin/configure-agent

RUN mkdir -p $HOME/gopath && \
    chown -R 1001:0 $HOME && \
    chown -R 1001:0 $HOME/gopath && \
    chmod -R g+rw $HOME && \
    chmod -R g+rw $HOME/gopath

ENV GOPATH=$HOME/gopath

USER 1001
