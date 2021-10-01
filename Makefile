PROJECT_NAME=test-container
DOCKERFILE_DIR     ?= ./images
DOCKER_REGISTRY    ?= quay.io
DOCKER_ORG         ?= strimzi-test-container
DOCKER_TAG         ?= main
DOCKER_VERSION_ARG ?= latest

all: prepare docker_build docker_tag_push clean

docker_build:
	./images/build_push_images.sh $(DOCKER_VERSION_ARG) $(PROJECT_NAME) $(DOCKER_TAG) $(DOCKERFILE_DIR)

docker_tag_push:
	./images/tag_push_images.sh $(PROJECT_NAME) $(DOCKER_REGISTRY) $(DOCKER_ORG) $(DOCKER_TAG) ($QUAY_USER) ($QUAY_PASS)

prepare: clean
	./images/download_kafka.sh

clean:
	rm -rf images/kafka_binaries
	rm -rf images/kafka_tars