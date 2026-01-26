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

# Create archive directory if it doesn't exist
mkdir -p $ARCHIVE_DIR

#####
# FOR EACH KAFKA VERSION SAVE IMAGE
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do
    CURRENT_TAG="$PRODUCT_VERSION-kafka-$KAFKA_VERSION"
    for ARCH in $ARCHITECTURES
    do
        IMAGE_NAME="strimzi/$PROJECT_NAME:$CURRENT_TAG-$ARCH"
        ARCHIVE_NAME="$PROJECT_NAME-$CURRENT_TAG-$ARCH.tar.gz"
        echo "[INFO] Saving image: $IMAGE_NAME to $ARCHIVE_DIR/$ARCHIVE_NAME"
        $DOCKER_CMD save $IMAGE_NAME | gzip > $ARCHIVE_DIR/$ARCHIVE_NAME
    done
done

echo "Finished saving images."
