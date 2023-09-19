#!/bin/bash

IMAGES_DIR="images"
CHECKSUMS_DIR="$IMAGES_DIR/checksums"
KAFKA_BINARIES_DIR="$IMAGES_DIR/kafka_binaries"
KAFKA_DOWNLOADED_TARS_DIR="$IMAGES_DIR/kafka_tars"

#####
# SUPPORTED KAFKA VERSIONS
#####
KAFKA_VERSIONS=$(cat supported_kafka.versions)

#####
# SUPPORTED SCALA VERSIONS
#####
SCALA_VERSION=$(cat supported_scala.version)

#####
# FOR EACH KAFKA VERSION DOWNLOAD BINARIES
#####
for KAFKA_VERSION in $KAFKA_VERSIONS
do

    mkdir -p $KAFKA_DOWNLOADED_TARS_DIR
    KAFKA_URL="https://dlcdn.apache.org/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz"
    echo $KAFKA_URL
    echo "Downloading: "$KAFKA_VERSION" with $SCALA_VERSION."

    if wget $KAFKA_URL -P "$KAFKA_DOWNLOADED_TARS_DIR"
    then
        echo "We successfully download Kafka from $KAFKA_URL"
    else
        echo "There was a problem downloading Kafka from $KAFKA_URL, we are gonna download it from archives."
        KAFKA_URL="https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz"

        if wget $KAFKA_URL -P "$KAFKA_DOWNLOADED_TARS_DIR"
        then
            echo "We successfully download Kafka from $KAFKA_URL"
        else
            echo "There was a problem downloading Kafka from $KAFKA_URL, we are gonna download it from release candidate."
            KAFKA_URL="https://home.apache.org/~satishd/kafka-$KAFKA_VERSION-rc0/kafka_2.13-$KAFKA_VERSION.tgz"
            if wget $KAFKA_URL -P "$KAFKA_DOWNLOADED_TARS_DIR"
            then
                echo "We successfully download Kafka from $KAFKA_URL"
            else
                echo "There was a problem downloading Kafka from $KAFKA_URL. Check if such URL is correct."
            fi
        echo "kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz"
        fi
    fi

    echo "[INFO] Expected Kafka SHA512SUM:"
    EXCEPTED_KAFKA_SHA512SUM=$(cat "$CHECKSUMS_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION.sha512")
    echo $EXCEPTED_KAFKA_SHA512SUM
    echo "[INFO] Downloaded Kafka SHA512SUM:"
    DOWNLOADED_KAFKA_SHA512SUM=$(cd $KAFKA_DOWNLOADED_TARS_DIR && sha512sum kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz)
    echo $DOWNLOADED_KAFKA_SHA512SUM

    if [ "$EXCEPTED_KAFKA_SHA512SUM" == "$DOWNLOADED_KAFKA_SHA512SUM" ]
    then
        echo "[INFO] SHA512SUMs are identical!"
    else
        echo "[ERROR] SHA512SUMs are not identical! Probably error during downloading..."
        exit 1
    fi

    echo "[INFO] Extracting: "$KAFKA_VERSION" with $SCALA_VERSION."
    mkdir -p $KAFKA_BINARIES_DIR && tar -xvzf $KAFKA_DOWNLOADED_TARS_DIR/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz -C $KAFKA_BINARIES_DIR
done

echo "Finished downloading.."