#!/bin/bash

#####
# DOCKER AND PROJECT auxiliary variables
#####
DOCKER_VERSION_ARG=$1
PROJECT_NAME_BASE=$2
ARCHITECTURES=$3
DOCKERFILE_BASE_DIR=$4

CURRENT_TAG=${CURRENT_TAG:-"local"}

####
# BUILD BASE IMAGES
####
for ARCH in $ARCHITECTURES
do
    echo "[INFO] Building image with name: strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH)."
    docker build --platform linux/$ARCH --build-arg version=$DOCKER_VERSION_ARG -t strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH $DOCKERFILE_BASE_DIR

    # "refresh" Docker's awareness of the image
    docker save strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH -o strimzi_base_$ARCH.tar
    docker load -i strimzi_base_$ARCH.tar
    # tagging this image eliminate this error
    #  ```
    #      ERROR: failed to solve: strimzi/base:local: pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
    #  ```
    # May be more likely to recognize this new tag as a local entity without trying to fetch it from a remote repository.
    # This specific tagging can help in resolving ambiguities that Docker might have had with the original image name and tag.
    docker tag strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH strimzi/$PROJECT_NAME_BASE:latest-$ARCH``
done

# PRINT ALL IMAGES
docker images

