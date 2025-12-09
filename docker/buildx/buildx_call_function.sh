#!/usr/bin/env bash

export example_image_name="jaisocx/testimage"
export example_image_tag="1.0.0-alpine-3.21.3"
export example_platforms="linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/386,linux/ppc64le,linux/riscv64,linux/s390x"


build_multiplatform_with_buildx() {
  local in_image_name="$1"
  local in_image_tag="$2"
  local in_platforms="$3"
  local in_path__folder_docker_image_context="$4"
  local in_nocache="$5"
  

  set -a
  local loc_path__env_for_dockerfile="${in_path__folder_docker_image_context}/.env"

  # echo "in_path__folder_docker_image_context: ${in_path__folder_docker_image_context}"
  # echo "loc_path__env_for_dockerfile: ${loc_path__env_for_dockerfile}"

  # imports docker service ENV variables from .env, 
  #    used in docker buildx build --build-arg 
  source "${loc_path__env_for_dockerfile}"


  docker buildx build $in_nocache \
    -t "${in_image_name}:${in_image_tag}" \
    --platform "${in_platforms}" \
    --build-arg JSC_IMAGE_NAME="${JSC_IMAGE_NAME}" \
    --build-arg JSC_IMAGE_SERVICE_NAME="${JSC_IMAGE_SERVICE_NAME}" \
    --build-arg TIME_ZONE="${TIME_ZONE}" \
    --build-arg GROUP_SUDIERS_ID="${GROUP_SUDIERS_ID}" \
    --build-arg GROUP_SUDIERS_NAME="${GROUP_SUDIERS_NAME}" \
    --build-arg GROUP_USERS_ID="${GROUP_USERS_ID}" \
    --build-arg GROUP_USERS_NAME="${GROUP_USERS_NAME}" \
    --build-arg USER_SUDIER_ID="${USER_SUDIER_ID}" \
    --build-arg USER_SUDIER_NAME="${USER_SUDIER_NAME}" \
    --build-arg USER_SUDIER_HASHED_PWD="${USER_SUDIER_HASHED_PWD}" \
    --build-arg USER_ID="${USER_ID}" \
    --build-arg USER_NAME="${USER_NAME}" \
    --build-arg LOGGED_IN_USERNAME="${LOGGED_IN_USERNAME}" \
    --build-arg VOLUME_PATH="${VOLUME_PATH}" \
    "${in_path__folder_docker_image_context}"

  set +a
}





### Tested command arg --build_arg:
# --build-arg LOGGED_IN_USERNAME="${LOGGED_IN_USERNAME}"
# when started docker service via docker compose,
# echo "${LOGGED_IN_USERNAME}" returnned the value from the .env file on time image build


