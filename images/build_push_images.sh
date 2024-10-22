#!/bin/bash

#####
# SUPPORTED KAFKA VERSIONS
#####
KAFKA_VERSIONS=$(cat supported_kafka.versions)

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
DOCKERFILE_DIR=$3
ARCHITECTURES=$4
DOCKER_CMD=$5

# PRINT ALL IMAGES
$DOCKER_CMD images

#####
# FOR EACH KAFKA VERSION BUILD IMAGE WITH DIFFERENT TAG (i.e., 'strimzi-test-container/test-container:0.1.0-kafka-2.8.1)
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do
    CURRENT_TAG="$PRODUCT_VERSION-kafka-$KAFKA_VERSION"
    echo "[INFO] Building images with following setup: DOCKER_VERSION_ARG=$DOCKER_VERSION_ARG, PROJECT_NAME=$PROJECT_NAME, PRODUCT_VERSION=$PRODUCT_VERSION, DOCKERFILE_DIR=$DOCKERFILE_DIR"

    for ARCH in $ARCHITECTURES
    do
        echo "[INFO] Building image with name: strimzi-test-container/$PROJECT_NAME:$CURRENT_TAG-$ARCH $KAFKA_VERSION with $SCALA_VERSION)."
        docker build --platform linux/$ARCH --build-arg version=$DOCKER_VERSION_ARG --build-arg KAFKA_VERSION=$KAFKA_VERSION --build-arg SCALA_VERSION=$SCALA_VERSION --build-arg ARCH=$ARCH -t strimzi/$PROJECT_NAME:$CURRENT_TAG-$ARCH $DOCKERFILE_DIR
    done
done


