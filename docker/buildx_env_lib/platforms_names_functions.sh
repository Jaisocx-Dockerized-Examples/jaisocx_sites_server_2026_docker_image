#!/usr/bin/env bash

this_script_platforms_folder_path="$(realpath "$(dirname "${BASH_SOURCE[0]:-$0}")")"

set -a
source "${this_script_platforms_folder_path}/.env.platforms_supported_by_alpine"
source "${this_script_platforms_folder_path}/env_miniobjects/env_miniobjects_transformer.sh"


getWellNamedCpuModelName() {
    local in_platform_miniobject="$1"
    local loc_const_field_name="model"

    local r_value="$(getByEnvMiniobject_Text "${in_platform_miniobject}" "${loc_const_field_name}")"

    echo "${r_value}"
}

getCpuArchitectureName() {
    local in_platform_miniobject="$1"
    local loc_const_field_name="name"

    local r_value="$(getByEnvMiniobject_Text "${in_platform_miniobject}" "${loc_const_field_name}")"

    echo "${r_value}"
}

getDockerBuildxPlatform() {
    local in_platform_miniobject="$1"
    local loc_const_field_name="platform"

    local r_value="$(getByEnvMiniobject_Text "${in_platform_miniobject}" "${loc_const_field_name}")"

    echo "${r_value}"
}


getAllPlatforms() {
    local in_all_platforms_names="$1"
    local loc_const_field_name="platform"

    local r_all_platforms="$(extractOneField_ByVariablesNames "${in_all_platforms_names}" "${loc_const_field_name}")"

    echo "${r_all_platforms}"
}


getAllPlatformsJson() {
    local in_all_platforms_names="$1"

    local r_json="$(toJson "${in_all_platforms_names}")"

    echo -e "${r_json}"
}




