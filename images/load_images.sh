#!/bin/bash

#####
# SUPPORTED KAFKA VERSIONS
#####
KAFKA_VERSIONS=$(cat supported_kafka.versions)

#####
# PRODUCT VERSION
#####
PRODUCT_VERSION=$(cat release.version)

#####
# DOCKER AND PROJECT auxiliary variables
#####
PROJECT_NAME=$1
ARCHITECTURES=$2
DOCKER_CMD=$3
ARCHIVE_DIR=${4:-./container-archives}

#####
# FOR EACH KAFKA VERSION LOAD IMAGE
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do
    CURRENT_TAG="$PRODUCT_VERSION-kafka-$KAFKA_VERSION"
    for ARCH in $ARCHITECTURES
    do
        ARCHIVE_NAME="$PROJECT_NAME-$CURRENT_TAG-$ARCH.tar.gz"
        echo "[INFO] Loading image from: $ARCHIVE_DIR/$ARCHIVE_NAME"
        $DOCKER_CMD load < $ARCHIVE_DIR/$ARCHIVE_NAME
    done
done

echo "Finished loading images."
