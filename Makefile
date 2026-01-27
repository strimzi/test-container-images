PROJECT_NAME=test-container
PROJECT_NAME_BASE=base
DOCKERFILE_DIR ?= ./images
DOCKERFILE_BASE_DIR ?= ./images/base
REGISTRY ?= quay.io
REGISTRY_ORGANIZATION ?= strimzi-test-container
IMAGE_TAG ?= main
DOCKER_VERSION_ARG ?= latest
ARCHS ?= amd64
DOCKER_CMD ?= docker
ARCHIVE_DIR ?= ./container-archives

all: docker_prepare_base_images prepare docker_build docker_tag_push clean

docker_prepare_base_images:
	./images/base/build_base_images.sh $(DOCKER_VERSION_ARG) $(PROJECT_NAME_BASE) "$(ARCHS)" $(DOCKERFILE_BASE_DIR) $(DOCKER_CMD)

docker_build:
	./images/build_push_images.sh $(DOCKER_VERSION_ARG) $(PROJECT_NAME) $(DOCKERFILE_DIR) "$(ARCHS)" $(DOCKER_CMD)

docker_save:
	./images/save_images.sh $(PROJECT_NAME) "$(ARCHS)" $(DOCKER_CMD) $(ARCHIVE_DIR)

docker_load:
	./images/load_images.sh $(PROJECT_NAME) "$(ARCHS)" $(DOCKER_CMD) $(ARCHIVE_DIR)

docker_tag_push:
	./images/tag_push_images.sh $(PROJECT_NAME) $(REGISTRY) $(REGISTRY_ORGANIZATION) $(QUAY_USER) $(QUAY_PASS) "$(ARCHS)" $(DOCKER_CMD)

prepare: clean
	./images/download_kafka.sh

clean:
	rm -rf images/kafka_binaries || true
	rm -rf images/kafka_tars || true
	rm -rf $(ARCHIVE_DIR) || true