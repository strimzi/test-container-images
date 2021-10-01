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
PROJECT_NAME=$1
DOCKER_REGISTRY=$2
DOCKER_ORG=$3
DOCKER_TAG=$4

# PRINT ALL IMAGES
docker images

echo "Login into registry..."
docker login -u $QUAY_USER -p $QUAY_PASS $DOCKER_REGISTRY/$DOCKER_ORG

#####
# FOR EACH KAFKA VERSION TAG AND PUSH IMAGE
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do
    CURRENT_TAG="$DOCKER_TAG-kafka-$KAFKA_VERSION"
    echo "[INFO] Tag images:"
    docker tag strimzi/$PROJECT_NAME:$CURRENT_TAG $DOCKER_REGISTRY/$DOCKER_ORG/$PROJECT_NAME:$CURRENT_TAG
    echo "[INFO] Push images with following setup: DOCKER_VERSION_ARG=$DOCKER_VERSION_ARG, PROJECT_NAME=$PROJECT_NAME, DOCKER_TAG=$DOCKER_TAG, DOCKERFILE_DIR=$DOCKERFILE_DIR"
    echo "[INFO] Pushing image with name: $DOCKER_REGISTRY/$DOCKER_ORG/$PROJECT_NAME:$CURRENT_TAG"
    docker push $DOCKER_REGISTRY/$DOCKER_ORG/$PROJECT_NAME:$CURRENT_TAG
done
