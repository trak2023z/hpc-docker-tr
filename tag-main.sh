#!/bin/bash

MAIN_DISTRO="debian"
MAIN_MPI_IMPLEMENTATION="mpich"
IMAGE_REPOSITORY="pikrog"

source "${MAIN_DISTRO}/.env"

MPI_VERSION_VAR=$(echo "${MAIN_MPI_IMPLEMENTATION}_VERSION" | tr [:lower:] [:upper:])
MAIN_MPI_VERSION="${!MPI_VERSION_VAR}"

##################
# Tag Base
##################
MAIN_BASE_IMAGE="${IMAGE_REPOSITORY}/${MAIN_MPI_IMPLEMENTATION}"
FULL_BASE_IMAGE="${MAIN_BASE_IMAGE}:${MAIN_MPI_VERSION}-${BASE_DISTRO_TAG}"
FULL_BASE_IMAGE_LATEST="${MAIN_BASE_IMAGE}:latest"
FULL_BASE_IMAGE_SHORT_VERSION="${MAIN_BASE_IMAGE}:${MAIN_MPI_VERSION}"

echo "Tagging ${FULL_BASE_IMAGE} as ${FULL_BASE_IMAGE_LATEST} and ${FULL_BASE_IMAGE_SHORT_VERSION}"

docker tag "${FULL_BASE_IMAGE}" "${FULL_BASE_IMAGE_LATEST}"
docker tag "${FULL_BASE_IMAGE}" "${FULL_BASE_IMAGE_SHORT_VERSION}"

##################
# Tag Node
##################
MAIN_NODE_IMAGE="${IMAGE_REPOSITORY}/${MAIN_MPI_IMPLEMENTATION}-node"
FULL_NODE_IMAGE="${MAIN_NODE_IMAGE}:${VERSION_TAG}-${BASE_DISTRO_TAG}"
FULL_NODE_IMAGE_LATEST="${MAIN_NODE_IMAGE}:latest"
FULL_NODE_IMAGE_SHORT_VERSION="${MAIN_NODE_IMAGE}:${VERSION_TAG}"

echo "Tagging ${FULL_NODE_IMAGE} as ${FULL_NODE_IMAGE_LATEST} and ${FULL_NODE_IMAGE_SHORT_VERSION}"

docker tag "${FULL_NODE_IMAGE}" "${FULL_NODE_IMAGE_LATEST}"
docker tag "${FULL_NODE_IMAGE}" "${FULL_NODE_IMAGE_SHORT_VERSION}"

##################
# Push
##################
echo "Pushing the new tags to the remote repository"

docker push "${FULL_BASE_IMAGE_LATEST}"
docker push "${FULL_BASE_IMAGE_SHORT_VERSION}"

docker push "${FULL_NODE_IMAGE_LATEST}"
docker push "${FULL_NODE_IMAGE_SHORT_VERSION}"
