PROJECT_NAME=test-kafka
DOCKERFILE_DIR     ?= ./images
DOCKER_REGISTRY    ?= quay.io
DOCKER_ORG         ?= $(USER)
DOCKER_TAG         ?= main
DOCKER_VERSION_ARG ?= latest

all: prepare docker_build docker_push clean

docker_build:
	./images/build_push_images.sh $(DOCKER_VERSION_ARG) $(PROJECT_NAME) $(DOCKER_TAG) $(DOCKERFILE_DIR)

prepare: clean
	./images/download_kafka.sh

clean:
	rm -rf images/kafka_binaries
	rm -rf images/kafka_tars