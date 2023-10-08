ARG ARCH=${ARCH}

FROM strimzi/base:latest-$ARCH

ARG KAFKA_VERSION
ARG SCALA_VERSION

USER root

# Add strimzi user with UID 1001
# The user is in the group 0 to have access to the mounted volumes and storage
RUN useradd -r -m -u 1001 -g 0 strimzi

#####
# Set JAVA_HOME env var
#####
ENV JAVA_HOME /usr/lib/jvm/jre-11
#####
# Add Kafka
#####
ENV KAFKA_HOME=/opt/kafka
#####
# Versions
#####
ENV KAFKA_VERSION=${KAFKA_VERSION}
ENV SCALA_VERSION=${SCALA_VERSION}

COPY ./kafka_binaries/kafka_${SCALA_VERSION}\-${KAFKA_VERSION} $KAFKA_HOME

WORKDIR $KAFKA_HOME

USER 1001