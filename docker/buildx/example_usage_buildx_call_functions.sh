#!/usr/bin/env bash

## How to run this script
# cd {PROJECT_ROOT}
# ./command/docker/image/image_new_tag.sh "jaisocx/testimage" "1.0.0" "linux/amd64,linux/arm64/v8" . --no-cache


# image_name="$1"
# image_tag="$2"
# platforms="$3"
# path="$(realpath "$4")"
# nocache="$5"


# ## docker image build: load file wih functions, and invoke bash function
# this_script_build_new_docker_image_folder_path="$(realpath "$(dirname "${BASH_SOURCE[0]:-$0}")")"
# pathToFunc="${this_script_build_new_docker_image_folder_path}/buildx_call_function.sh"
# source "${pathToFunc}"


# build_multiplatform_with_buildx "${image_name}" "${image_tag}" "${platforms}" "${path}" "${nocache}"



