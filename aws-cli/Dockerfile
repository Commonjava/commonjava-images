FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL Component="nos-aws-cli" \
    Name="nos-aws-cli" \
    Version="1" \
    Release="1" \
    maintainer="RedHat SPMM Team <nos-devel@redhat.com>"

ARG USER=aws
ARG UID=10000
ARG HOME_DIR=/home/${USER}

USER root
ENV TZ UTC

ADD 2022-IT-Root-CA.pem /etc/pki/ca-trust/source/anchors/2022-IT-Root-CA.pem
RUN update-ca-trust extract

RUN microdnf -y update && \
    microdnf -y install glibc groff-base less shadow-utils unzip && \
    microdnf clean all && \
    rm -rf /var/cache/yum

RUN useradd -d ${HOME_DIR} -u ${UID} -g 0 -m -s /bin/bash ${USER} \
    && chown ${USER}:0 ${HOME_DIR} \
    && chmod -R g+rwx ${HOME_DIR} \
    && chmod g+rw /etc/passwd

ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /tmp/aws/awscliv2.zip
RUN unzip /tmp/aws/awscliv2.zip -d /tmp/aws
RUN rm /tmp/aws/awscliv2.zip \
    && /tmp/aws/aws/install \
    && rm -rf /tmp/aws
RUN chmod +x /usr/local/bin/*

USER ${USER}
ENV HOME=${HOME_DIR} \
    LANG=en_US.UTF-8

WORKDIR ${HOME_DIR}

CMD ["bash"]
