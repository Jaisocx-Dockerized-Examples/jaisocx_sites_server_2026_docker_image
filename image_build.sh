#!/usr/bin/env bash

# USE
# cd {PROJECT_ROOT}

### when docker image tag set here on line after 17
# ./image_build.sh 
# ./image_build.sh --push
# ./image_build.sh --push --latest

### when docker image tag set the command first arg
# ./image_build.sh "1.2.0-alpine-3.21.3"
# ./image_build.sh "1.2.0-alpine-3.21.3" --push
# ./image_build.sh "1.2.0-alpine-3.21.3" --push --latest


jaisocx_lib_for_docker__path="docker"
path__folder_current_docker_image_context="$(realpath "$(dirname "${BASH_SOURCE[0]:-$0}")")"

bash -c ""${jaisocx_lib_for_docker__path}/buildx/main_build_docker_image.sh" "${path__folder_current_docker_image_context}" "${@:2}""


# image_name="jaisocx/testimage"
# image_tag="1.5.6-alpine-3.21.3" 
# # image_tag="1.5.5-alpine-3.21.3" # 1.5.1 with Curl library, build for several architectures. Users and groups, .env load feature, bound volume example, platform_apple_silicon="linux/arm64/v8"
# # image_tag="1.5.4-alpine-3.21.3" # 1.5.1 with Curl library. Users and groups, .env load feature, bound volume example, platform_apple_silicon="linux/arm64/v8"
# # image_tag="1.5.1-alpine-3.21.3" # Users and groups, .env load feature, bound volume example, platform_apple_silicon="linux/arm64/v8"
# # image_tag="1.4.10-alpine-3.21.3" Alpine 3.21.3, Java 21 JDK JRE-headless, platform_apple_silicon="linux/arm64/v8"
# # image_tag="1.4.9-alpine-3.21.3" # Alpine 3.21.3, without other packages, all_platforms="linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/386,linux/ppc64le,linux/riscv64,linux/s390x"
# # image_tag="1.4.8-alpine-3.21.3" # Alpine 3.21.3, Java 21 JDK JRE, platform_apple_silicon="linux/arm64/v8"
# # image_tag="latest"




