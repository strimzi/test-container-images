PROJECT_NAME=test-container-images
DOCKERFILE_DIR     ?= ./images
DOCKER_REGISTRY    ?= quay.io
DOCKER_ORG         ?= $(USER)
DOCKER_TAG         ?= latest
DOCKER_VERSION_ARG ?= latest

all: prepare docker_build docker_push clean

docker_build:
	echo "Building Docker images ..."
	./images/build_images.sh $(DOCKER_VERSION_ARG) $(PROJECT_NAME) $(DOCKER_TAG) $(DOCKERFILE_DIR)

docker_push:
	echo "Pushing $(DOCKER_REGISTRY)/$(DOCKER_ORG)/$(PROJECT_NAME):$(DOCKER_TAG) ..."
	docker push $(DOCKER_REGISTRY)/$(DOCKER_ORG)/$(PROJECT_NAME):$(DOCKER_TAG)

prepare: clean
	./images/download_kafka.sh

clean:
	rm -rf images/kafka_binaries
	rm -rf images/kafka_tars