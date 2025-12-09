#!/usr/bin/env sh

env_variable() {
  local loc_env_file_path="$1"
  local loc_env_variable_name="$2"
  local loc_env_variable_value=""

  if [ ! -f "${loc_env_file_path}" ]; then
    echo "File not found: ${loc_env_file_path}"
    exit 1;
  fi



  ### Parse the file and assign to env
  IFS="\n"

  while read in_line; do

      line="$(echo "${in_line}" | xargs)"

      if [ -z "${line}" ]; then
          # echo "Empty line"
          continue
      fi

      if [[ "${line}" =~ ^# ]]; then
          # echo "Comment line"
          continue
      fi
  
      key=$(printf "%s" "$line" | cut -d'=' -f1)
      value=$(printf "%s" "$line" | cut -d'=' -f2-)

      # local key="${array_keyvalue_pair[0]}"
      key=$(echo "${key}" | xargs)

      if [[ "${key}" != "${loc_env_variable_name}" ]]; then
          continue
      fi
      
      # value="${array_keyvalue_pair[1]}"
      loc_env_variable_value=$(echo "${value}" | xargs)
      
      break
      
  done < "${loc_env_file_path}"
  unset IFS

  echo "${loc_env_variable_value}"
  exit 0
}

if [ -n "$1" ]; then
  env_variable_value="$(env_variable "$1" "$2")"
  echo "${env_variable_value}"
fi




