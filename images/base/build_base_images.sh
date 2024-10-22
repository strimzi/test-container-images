#!/bin/bash

#####
# DOCKER AND PROJECT auxiliary variables
#####
DOCKER_VERSION_ARG=$1
PROJECT_NAME_BASE=$2
ARCHITECTURES=$3
DOCKERFILE_BASE_DIR=$4
DOCKER_CMD=$5

CURRENT_TAG=${CURRENT_TAG:-"local"}
OAUTH_LIB_VERSION=${OAUTH_LIB_VERSION:-0.15.0}

####
# BUILD BASE IMAGES
####
for ARCH in $ARCHITECTURES
do
    echo "[INFO] Building classic image with name: strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH)."
    $DOCKER_CMD build --platform linux/$ARCH \
                    --build-arg version=$DOCKER_VERSION_ARG \
                    --build-arg OAUTH_LIB_VERSION=$OAUTH_LIB_VERSION \
                    -t strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH $DOCKERFILE_BASE_DIR

    # "refresh" Docker's awareness of the image
    $DOCKER_CMD save strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH -o strimzi_base_$ARCH.tar
    $DOCKER_CMD load -i strimzi_base_$ARCH.tar
    # tagging this image eliminate this error
    #  ```
    #      ERROR: failed to solve: strimzi/base:local: pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
    #  ```
    # May be more likely to recognize this new tag as a local entity without trying to fetch it from a remote repository.
    # This specific tagging can help in resolving ambiguities that Docker might have had with the original image name and tag.
    $DOCKER_CMD tag strimzi/$PROJECT_NAME_BASE:$CURRENT_TAG-$ARCH strimzi/$PROJECT_NAME_BASE:latest-$ARCH``
done

# PRINT ALL IMAGES
$DOCKER_CMD images

