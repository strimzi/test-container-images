#!/bin/bash

#####
# SUPPORTED KAFKA VERSIONS
#####
KAFKA_VERSIONS=$(cat supported_kafka.version)

#####
# SUPPORTED SCALA VERSIONS
#####
SCALA_VERSION=$(cat supported_scala.version)

#####
# PRODUCT VERSION
#####
PRODUCT_VERSION=$(cat release.version)

#####
# DOCKER AND PROJECT auxiliary variables
#####
DOCKER_VERSION_ARG=$1
PROJECT_NAME=$2
DOCKER_TAG=$3
DOCKERFILE_DIR=$4

#####
# FOR EACH KAFKA VERSION DOWNLOAD BINARIES
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do
    CURRENT_PROJECT="$PROJECT_NAME-$KAFKA_VERSION"
    echo "[INFO] Building images with following setup: DOCKER_VERSION_ARG=$DOCKER_VERSION_ARG, CURRENT_PROJECT=$CURRENT_PROJECT, DOCKER_TAG=$DOCKER_TAG, DOCKERFILE_DIR=$DOCKERFILE_DIR"
    echo "[INFO] Building image with name: strimzi/$CURRENT_PROJECT:$DOCKER_TAG $KAFKA_VERSION with $SCALA_VERSION)."
    docker build --build-arg version=$DOCKER_VERSION_ARG --build-arg KAFKA_VERSION=$KAFKA_VERSION --build-arg SCALA_VERSION=$SCALA_VERSION -t strimzi/$CURRENT_PROJECT:$DOCKER_TAG $DOCKERFILE_DIR
done

