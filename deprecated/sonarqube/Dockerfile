FROM quay.io/factory2/nos-java-base:latest

USER root

COPY 99-sonarqube-limits.conf /etc/security/limits.d/99-sonarqube.conf
COPY 99-sonarqube-sysctl.conf /etc/sysctl.d/99-sonarqube.conf
COPY common-session /etc/pam.d/
COPY common-session-noninteractive /etc/pam.d/

ARG SONARQUBE_VERSION=8.7.0.41497
ARG SONARQUBE_ZIP_URL=https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip

RUN yum remove -y java-1.8.0-openjdk java-1.8.0-openjdk-headless && \
    yum install -y java-11-openjdk java-11-openjdk-headless gcc gnupg unzip curl && yum clean all

ENV SONARQUBE_HOME=/opt/sonarqube \
    SONAR_VERSION="${SONARQUBE_VERSION}" \
    SQ_DATA_DIR="/opt/sonarqube/data" \
    SQ_CONF_DIR="/opt/sonarqube/conf" \
    SQ_EXTENSIONS_DIR="/opt/sonarqube/extensions" \
    SQ_LOGS_DIR="/opt/sonarqube/logs" \
    SQ_TEMP_DIR="/opt/sonarqube/temp" 

# hadolint ignore=SC2115
RUN set -eux; \
    groupadd  -g 1000 sonarqube; \
    useradd -u 1000 -g sonarqube sonarqube; \
    mkdir -p /opt; \
    cd /opt; \
    curl --fail --location --output sonarqube.zip --silent --show-error "${SONARQUBE_ZIP_URL}"; \
    unzip -q sonarqube.zip; \
    mv "sonarqube-${SONARQUBE_VERSION}" "${SONARQUBE_HOME}"; \
    rm sonarqube.zip*; \
    rm -rf "${SONARQUBE_HOME}/bin"/*; \
    chown -R sonarqube:sonarqube "${SONARQUBE_HOME}"; \
    # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
    chmod -R 777 "${SQ_DATA_DIR}" "${SQ_EXTENSIONS_DIR}" "${SQ_LOGS_DIR}" "${SQ_TEMP_DIR}"; 

COPY --chown=sonarqube:sonarqube run.sh sonar.sh ${SONARQUBE_HOME}/bin/

RUN chmod +x "${SONARQUBE_HOME}"/bin/*.sh

USER sonarqube

WORKDIR "${SONARQUBE_HOME}"
EXPOSE 9000
ENTRYPOINT ["bin/run.sh"]
CMD ["bin/sonar.sh"]