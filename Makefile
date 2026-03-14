include ./Makefile.os
include ./Makefile.docker

PROJECT_NAME=test-container
PROJECT_NAME_BASE=base
DOCKERFILE_BASE_DIR ?= ./images/base

DOCKER_TARGETS = docker_build docker_push docker_tag docker_load docker_save docker_delete_archive docker_amend_manifest docker_gha_sign_manifest docker_gha_sbom docker_gha_push_sbom

all: clean prepare docker_build

clean:
	rm -rf images/kafka_binaries || true
	rm -rf images/kafka_tars || true
	rm -rf images/base/strimzi_base_*.tar || true
	rm -rf $(ARCHIVE_DIR) || true
