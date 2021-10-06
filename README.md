[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![Twitter Follow](https://img.shields.io/twitter/follow/strimziio.svg?style=social&label=Follow&style=for-the-badge)](https://twitter.com/strimziio)

# Test container images

This repository contains code to compile the image used in the [strimzi/test-container](https://github.com/strimzi/test-container) repository. 
The overall workflow is that if a new version of Kafka is published using `build_pipeline`, we release a brand new image with Kafka version containing Kafka binaries.
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
