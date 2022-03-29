[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![Twitter Follow](https://img.shields.io/twitter/follow/strimziio.svg?style=social&label=Follow&style=for-the-badge)](https://twitter.com/strimziio)

# Test container images

This repository contains code to compile the image used in the [strimzi/test-container](https://github.com/strimzi/test-container) repository. 
The overall workflow is that if a new version of [Apache Kafka®](https://kafka.apache.org) is published using `build_pipeline`, we release a brand new image with Kafka version containing Kafka binaries.
Moreover, the image can be used in other forms of deployment using a classic `docker` container or `docker-compose`.

# How to use

Pulling images can be achieved with following command:
```shell
docker pull strimzi-test-container/test-container:<test-container-image-version>-kafka-<kafka-version>
```

example:
```shell
// download image with the 0.1.0 version and Kafka 3.0.0
docker pull strimzi-test-container/test-container:0.1.0-kafka-3.0.0
````

# How the image is built

The build process is divided into 3 phases:
1. Download Kafka binaries
2. Next, we build for each Kafka version the same image but with different tag (i.e., `test-container:latest-kafka-3.0.0`, `test-container:latest-kafka-2.8.1`)
```shell
docker build --build-arg version=$DOCKER_VERSION_ARG --build-arg KAFKA_VERSION=$KAFKA_VERSION --build-arg SCALA_VERSION=$SCALA_VERSION -t strimzi/$PROJECT_NAME:$CURRENT_TAG $DOCKERFILE_DIR
```
3. Eventually, we tag this image and then push it into the container repository
```shell
// tag image
docker tag strimzi/$PROJECT_NAME:$CURRENT_TAG $REGISTRY/$REGISTRY_ORGANIZATION/$PROJECT_NAME:$CURRENT_TAG
// push image
docker push $REGISTRY/$REGISTRY_ORGANIZATION/$PROJECT_NAME:$CURRENT_TAG
```
