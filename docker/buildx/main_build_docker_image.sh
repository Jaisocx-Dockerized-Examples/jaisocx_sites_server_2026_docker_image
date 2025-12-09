#!/usr/bin/env bash

# USE
# cd {PROJECT_ROOT}


# ./main_build_docker_image.sh "$context_path"
# ./main_build_docker_image.sh "$context_path" --push
# ./main_build_docker_image.sh "$context_path" --push --latest


### when docker image tag set the command arg on position $2
# ./main_build_docker_image.sh "$context_path" "1.2.0-alpine-3.21.3"
# ./main_build_docker_image.sh "$context_path" "1.2.0-alpine-3.21.3" --push
# ./main_build_docker_image.sh "$context_path" "1.2.0-alpine-3.21.3" --push --latest


if [[ -n "$2" && "$2" != "--push" ]]; then
  image_tag="$2"
fi

# just pushes the image and exits, if --push command arg is set
if [[ "$2" == "--push" || "$3" == "--push" ]]; then
  if [[ "$3" == "--latest" || "$4" == "--latest" ]]; then
    docker push "${image_name}:${image_tag}"

    # If you've already built an image, you can add another tag to the image by using the docker image tag command:
    # docker image tag --help
    # Usage:  docker image tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
    # Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
    # docker image tag "jaisocx/testimage:1.3.0-alpine-3.21.3" "jaisocx/testimage:latest"
    docker image tag "${image_name}:${image_tag}" "${image_name}:latest"
    docker push "${image_name}:latest"
  else 
    docker push "${image_name}:${image_tag}"
  fi

  exit 0
fi





## PATHS TO IMPORTS
path__folder_this_script_main_build_docker_image="$(realpath "$(dirname "${BASH_SOURCE[0]:-$0}")")"
path__platforms_names_functions="$(realpath "${path__folder_this_script_main_build_docker_image}/../buildx_env_lib/platforms_names_functions.sh")"
path__buildx_functions="${path__folder_this_script_main_build_docker_image}/buildx_call_function.sh"
# path__build_functions="${path__folder_this_script_main_build_docker_image}/build_new_docker_image_with_tag.sh"


path__folder_current_docker_image_context="$1"
echo "path__folder_current_docker_image_context: ${path__folder_current_docker_image_context}"
path__file_current_docker_image__buildx_env="${path__folder_current_docker_image_context}/buildx.env"
# info: path__file_current_docker_image__dockerfile_env="${path__folder_current_docker_image_context}/.env"





## IMPORTS
## allows imports from .env files
set -a


## imports buildx.env for multiplatform docker image build settings
## file buildx.env imports image build settings: 
# image_name
# image_tag
# PLATFORMS_NAMES_BUILD_WITH
# nocache
source "${path__file_current_docker_image__buildx_env}" 


## imports functions for buildx build --platform 
source "${path__platforms_names_functions}"
## platforms_names_functions.sh EXAMPLES:
# platform="$(getDockerBuildxPlatform "${Intel}")"
# platform="$(getDockerBuildxPlatform "${Apple_Silicon}")"
# platform="$(getDockerBuildxPlatformName "${Platform_32_bit}")"


## imports function build_multiplatform_with_buildx image_name, image_tag, platforms, docker image context, no cache
source "${path__buildx_functions}"






## variable PLATFORMS_NAMES_BUILD_WITH imported from buildx.env
platforms=""
if [[ "${PLATFORMS_NAMES_BUILD_WITH}" == "ALL_PLATFORMS_BUILDX_NAMES" ]]; then
    platforms="${ALL_PLATFORMS_BUILDX_NAMES}"
else
    ## gets platforms from "command/docker/multiplatform/.env.platforms_supported_by_alpine"
    platforms="$(getAllPlatforms "${PLATFORMS_NAMES_BUILD_WITH}")"
fi




### ----------------------------------------------------
### command args examples
### ----------------------------------------------------
# image_name="jaisocx/testimage"
# image_tag="1.2.0-alpine-3.21.3" # or image_tag="latest"
# platforms="linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/386,linux/ppc64le,linux/riscv64,linux/s390x"
# path="${path__folder_current_docker_image_context}"
# nocache="--no-cache" # or, nocache=""



# bash -c ""${path__build_functions}" "${image_name}" "${image_tag}" "${platforms}" "${path__folder_current_docker_image_context}" "${nocache}""

build_multiplatform_with_buildx "${image_name}" "${image_tag}" "${platforms}" "${path__folder_current_docker_image_context}" "${nocache}"




