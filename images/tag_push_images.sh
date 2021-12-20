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
PROJECT_NAME=$1
REGISTRY=$2
REGISTRY_ORGANIZATION=$3
QUAY_USER=$4
QUAY_PASS=$5
PLATFORMS=$6
DOCKER_VERSION_ARG=$7
DOCKERFILE_DIR=$8

# PRINT ALL IMAGES
docker images

echo "Login into registry..."
docker login -u $QUAY_USER -p $QUAY_PASS $REGISTRY

docker buildx create --use

#####
# FOR EACH KAFKA VERSION TAG AND PUSH IMAGE
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do
    CURRENT_TAG="$PRODUCT_VERSION-kafka-$KAFKA_VERSION"
    echo "[INFO] Building and pushing images with following setup: DOCKER_VERSION_ARG=$DOCKER_VERSION_ARG, PROJECT_NAME=$PROJECT_NAME, PRODUCT_VERSION=$PRODUCT_VERSION, DOCKERFILE_DIR=$DOCKERFILE_DIR"
    echo "[INFO] Building and pushing image with name: $REGISTRY/$REGISTRY_ORGANIZATION/$PROJECT_NAME:$CURRENT_TAG $KAFKA_VERSION with $SCALA_VERSION)."
    docker buildx build --push --platform=$PLATFORMS --build-arg version=$DOCKER_VERSION_ARG --build-arg KAFKA_VERSION=$KAFKA_VERSION --build-arg SCALA_VERSION=$SCALA_VERSION --tag $REGISTRY/$REGISTRY_ORGANIZATION/$PROJECT_NAME:$CURRENT_TAG $DOCKERFILE_DIR
done