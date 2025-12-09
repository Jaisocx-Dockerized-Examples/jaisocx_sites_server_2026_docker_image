#!/usr/bin/env bash

# this_script_test_sh_folder_path="$(realpath "$(dirname "$0")")"


# set -a
# source "${this_script_test_sh_folder_path}/command/docker/multiplatform/.env.platforms_supported_by_alpine"
# # Array Key model:    Pretty CPU Model Name
# # Array Key name:     CPU Architecture Name
# # Array Key platform: Docker Buildx Build command arg --platform

# source "${this_script_test_sh_folder_path}/command/docker/multiplatform/platforms.sh"


# file_to_export_to="${this_script_test_sh_folder_path}/buildx.env"
# IFS=',';
# for key in ${all_platforms_variables_names}; do
#   key="$(echo "$key" | xargs)"
#   platform="$(getByEnvMiniobject_Name "$key" "platform")"

#   line="${key}=${platform}"

#   echo "${line}" >> "${file_to_export_to}"
# done;



# platform="$(getDockerBuildxPlatform "${platform_miniobject}")"
# echo -e "$platform"



# echo "getAllPlatformsJson:"
# json="$(getAllPlatformsJson "${all_platforms_variables_names}")"
# echo -e "${json}"
# echo -e "${json}" > "./test_json_export.json"
# echo "--------------------------------"
# echo ""



# echo "getAllPlatforms:"
# all_platforms="$(getAllPlatforms "${all_platforms_variables_names}")"
# echo "${all_platforms}"
# echo "--------------------------------"
# echo ""



# platform_miniobject="${Apple_Silicon}"
# model="$(getWellNamedCpuModelName "${platform_miniobject}")"
# echo -e "$model"
# echo "--------------------------------"

# name="$(getCpuArchitectureName "${platform_miniobject}")"
# echo -e "$name"
# echo "--------------------------------"

# platform="$(getDockerBuildxPlatform "${platform_miniobject}")"
# echo -e "$platform"
# echo "--------------------------------"






