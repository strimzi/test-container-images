PROJECT_NAME=test-container
PROJECT_NAME_BASE=base
DOCKERFILE_DIR ?= ./images
DOCKERFILE_BASE_DIR ?= ./images/base
REGISTRY ?= quay.io
REGISTRY_ORGANIZATION ?= strimzi-test-container
IMAGE_TAG ?= main
DOCKER_VERSION_ARG ?= latest
ARCHS ?= amd64

all: docker_prepare_base_images prepare docker_build docker_tag_push clean

docker_prepare_base_images:
	./images/base/build_tag_push_base_images.sh $(DOCKER_VERSION_ARG) $(PROJECT_NAME_BASE) "$(ARCHS)" $(DOCKERFILE_BASE_DIR)

docker_build:
	./images/build_push_images.sh $(DOCKER_VERSION_ARG) $(PROJECT_NAME) $(DOCKERFILE_DIR) "$(ARCHS)"

docker_tag_push:
	./images/tag_push_images.sh $(PROJECT_NAME) $(REGISTRY) $(REGISTRY_ORGANIZATION) $(QUAY_USER) $(QUAY_PASS) "$(ARCHS)"

prepare: clean
	./images/download_kafka.sh

clean:
	rm -rf images/kafka_binaries
	rm -rf images/kafka_tars