#!/bin/bash

IMAGES_DIR="images"
KAFKA_BINARIES_DIR="$IMAGES_DIR/kafka_binaries"
KAFKA_DOWNLOADED_TARS_DIR="$IMAGES_DIR/kafka_tars"

#####
# SUPPORTED KAFKA AND SCALA VERSIONS
#####
KAFKA_VERSIONS=$(cat supported_kafka.version)
SCALA_VERSIONS=$(cat supported_scala.version)

#####
# FOR EACH KAFKA VERSION DOWNLOAD BINARIES
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do
    for SCALA_VERSION in $SCALA_VERSIONS
    do
        echo "Downloading: "$KAFKA_VERSION" with $SCALA_VERSION."
        KAFKA_URL="https://dlcdn.apache.org/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz"
        mkdir -p $KAFKA_DOWNLOADED_TARS_DIR && wget $KAFKA_URL -P "$KAFKA_DOWNLOADED_TARS_DIR"
        echo "kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz"
        echo "Extracting: "$KAFKA_VERSION" with $SCALA_VERSION."
        mkdir -p $KAFKA_BINARIES_DIR && tar -xvzf $KAFKA_DOWNLOADED_TARS_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz -C $KAFKA_BINARIES_DIR
    done
done

echo "Finished downloading..."