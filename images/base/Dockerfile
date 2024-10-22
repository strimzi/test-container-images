FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

USER root

ARG OAUTH_LIB_VERSION=0.15.0
ARG NIMBUS_JOSE_JWT_VERSION=9.37.2

# Install Java and other necessary packages
RUN microdnf update -y && \
    microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y \
    java-17-openjdk-headless shadow-utils wget && \
    microdnf clean all

# Download OAuth libraries
RUN echo "Including OAuth libraries in the base image..." && \
    mkdir -p /opt/kafka/oauth-libs && \
    OAUTH_COMMON_URL="https://repo1.maven.org/maven2/io/strimzi/kafka-oauth-common/${OAUTH_LIB_VERSION}/kafka-oauth-common-${OAUTH_LIB_VERSION}.jar" && \
    OAUTH_SERVER_URL="https://repo1.maven.org/maven2/io/strimzi/kafka-oauth-server/${OAUTH_LIB_VERSION}/kafka-oauth-server-${OAUTH_LIB_VERSION}.jar" && \
    OAUTH_SERVER_PLAIN_URL="https://repo1.maven.org/maven2/io/strimzi/kafka-oauth-server-plain/${OAUTH_LIB_VERSION}/kafka-oauth-server-plain-${OAUTH_LIB_VERSION}.jar" && \
    OAUTH_KEYCLOAK_AUTHORIZER_URL="https://repo1.maven.org/maven2/io/strimzi/kafka-oauth-keycloak-authorizer/${OAUTH_LIB_VERSION}/kafka-oauth-keycloak-authorizer-${OAUTH_LIB_VERSION}.jar" && \
    OAUTH_CLIENT_URL="https://repo1.maven.org/maven2/io/strimzi/kafka-oauth-client/${OAUTH_LIB_VERSION}/kafka-oauth-client-${OAUTH_LIB_VERSION}.jar" && \
    NIMBUS_JOSE_JWT_URL="https://repo1.maven.org/maven2/com/nimbusds/nimbus-jose-jwt/${NIMBUS_JOSE_JWT_VERSION}/nimbus-jose-jwt-${NIMBUS_JOSE_JWT_VERSION}.jar" && \
    wget -P /opt/kafka/oauth-libs "$OAUTH_COMMON_URL" "$OAUTH_SERVER_URL" "$OAUTH_SERVER_PLAIN_URL" \
    "$OAUTH_KEYCLOAK_AUTHORIZER_URL" "$OAUTH_CLIENT_URL" "$NIMBUS_JOSE_JWT_URL"