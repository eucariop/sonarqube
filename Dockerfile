FROM registry.access.redhat.com/ubi8/ubi
# FROM registry.cirrus.ibm.com/public/ubi8

LABEL name="SonarQube Image" \
      vendor="SonarSource" \
      maintainer="Eucario Padro <eucario.padro@ibm.com>" \
      build-date="2021-02-16" \
      version="${SONARQUBE_VERSION}" \
      release="1"

# ENV SONARQUBE_VERSION=7.9.1 \
# ENV SONARQUBE_VERSION=7.9.5 \
ENV SONARQUBE_VERSION=8.6.1.40680 \
    SONARQUBE_USER=sonarqube \
    SONARQUBE_BASE=/opt \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_PORT=9000 \
    SONARQUBE_JDBC_USERNAME="" \
    SONARQUBE_JDBC_PASSWORD="" \
    SONARQUBE_JDBC_URL="" \
    SONARQUBE_SEARCH_JVM_OPTS="" \
    SONARQUBE_WEB_JVM_OPTS="" \
    SONARQUBE_EXTRA_ARGS="" \
    SONARQUBE_IMAGE=""


COPY helpers/* /usr/bin/

RUN yum -y install java-11-openjdk-headless nss_wrapper unzip && \
    yum -y clean all && \
    cd ${SONARQUBE_BASE} && \
    curl -o sonarqube.zip -SL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-${SONARQUBE_VERSION} sonarqube && \
    rm -rf sonarqube.zip* && \
    rm -rf ${SONARQUBE_HOME}/bin/* && \
    cd ${SONARQUBE_HOME}

RUN useradd -m -g 0 ${SONARQUBE_USER} && \
    chgrp -R 0 ${SONARQUBE_HOME} && \
    chmod -R g+rwX ${SONARQUBE_HOME}

USER ${SONARQUBE_USER}

EXPOSE ${SONARQUBE_PORT}
WORKDIR ${SONARQUBE_HOME}

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["run-sonarqube"]
