#!/usr/bin/env bash

set    -xea

file_env_entry="$1"
source "${file_env_entry}"

ls -la "${file_env_entry}"
cat "${file_env_entry}"

file_env_current="$2"

IFS=$'\n'; for cy_env_entry_line in ${lines}; do

  variable_name="$(echo "${cy_env_entry_line}" | cut -d"=" -f1 | xargs)"
  eval "variable_value=\"\$${variable_name}\""
  env_entry_line="export ${variable_name}=\"${variable_value}\""
  eval "${env_entry_line}"

done < "${file_env_current}"




# var container_builds imported from file_image_markers
# on container build, erase jaisocx_rc_installed_marker
# container build is assumed, when a file in a volume to mount does not exist
# or has been deleted to invoke installation tasks 
# "${file_image_markers_in_log_folder}"
# /var/log/jaisocx/installations_markers
if [[ "${container_builds}" == "true" ]]; then
  echo -e " " > "${file_image_markers}"

  if [[ -x "${file_image_markers_in_log_folder}" ]]; then
    echo -e " " > "${file_image_markers_in_log_folder}"
  fi
  
fi



### the feature to adjust on demand the owning user id of the mapped volumes to .env LOGGED_IN_USERNAME id and GROUP_USERS_ID = id of the GROUP_USERS_NAME

jaisocx_rc_installed_marker=""

if [ -x "${file_image_markers_in_log_folder}" ]; then
  export jaisocx_rc_installed_marker="$(cat "${file_image_markers_in_log_folder}" | grep "${JSC_IMAGE_SERVICE_NAME}")"
fi

if [[ -z "${jaisocx_rc_installed_marker}" ]]; then

  chown  -R "${LOGGED_IN_USERNAME}:${GROUP_USERS_NAME}" "${folder_image_mounted_software_jsc_image_service}"
  chown  -R "${LOGGED_IN_USERNAME}:${GROUP_USERS_NAME}" "${folder_image_mounted_data}"
  chown  -R "${LOGGED_IN_USERNAME}:${GROUP_USERS_NAME}" "${folder_image_mounted_logs}"
  
  chmod  -R u+rwx "${folder_image_mounted_software_jsc_image_service}"
  chmod  -R g+rwx "${folder_image_mounted_software_jsc_image_service}"
  chmod  -R o+rwx "${folder_image_mounted_software_jsc_image_service}"

  chmod  -R u+rwx "${folder_image_mounted_data}"
  chmod  -R g+rwx "${folder_image_mounted_data}"
  chmod  -R o+rwx "${folder_image_mounted_data}"

  mkdir  -p       "${folder_image_mounted_logs_jsc_image_service}"
  chown  -R       "${LOGGED_IN_USERNAME}:${GROUP_USERS_NAME}" "${folder_image_mounted_logs_jsc_image_service}"

  touch           "${file_image_markers_in_log_folder}"
  touch           "${file_image_service_start_markers_in_log_folder}"

  chmod  -R u+rwx "${folder_image_mounted_logs_jsc_image_service}"
  chmod  -R g+rwx "${folder_image_mounted_logs_jsc_image_service}"
  chmod  -R o+r   "${folder_image_mounted_logs_jsc_image_service}"

  echo            "${JSC_IMAGE_SERVICE_NAME}" >> "${file_image_markers_in_log_folder}"
fi


jaisocx_rc_installed_marker="$(cat "${file_image_markers_in_log_folder}" | grep "${JSC_IMAGE_SERVICE_NAME}")"
if [[ -z "${jaisocx_rc_installed_marker}" ]]; then
  exit 1;
fi


# TEMP DEBUGGING INFOS
echo "$(date | xargs) entrypoint. var LOGGED_IN_USERNAME: ${LOGGED_IN_USERNAME}" >> "${file_image_markers_in_log_folder}"
echo "$(date | xargs) entrypoint. user: $(id)" >> "${file_image_markers_in_log_folder}"






# starting rc-service jaisocx
# add other background-mode services
# or run a foreground service with &
# e.g. java -jar java_server.jar &



### OPENRC BACKGROUNDMODE

# 1. when backgroundmode=true
#     the docker needs 
#     trap and wait $pid1 feature. 
#       since the docker engine normally finishes, when no foreground process with blocking read or similar methods.

# 2. backgroundmode=false
# FOREGROUND
#    after ( openrc "default" )
#       NO entrypoint.sh code lines are done.
#       docker service serves the sites on the SitesServer.
#       

# 3. backgroundmode=false && ( openrc "default" & )
# same as 1. BACKGROUND and docker needs
#   trap and wait $pid1



### TRAP AND WAIT $pid1
# NOT READY AND FOR NOW DOES NOT DO NO GOOD AT ALL. NO DOCKER RESTART EVEN. OPENRC NEITHER.
#     needs subcall .sh function, invoked in trap payload.
#     since for now the expression kill $pid1 $pid2; wait $pid1 $pid2;
#     erased both $pid1 and did not start no new process with valid process id to wait for.
#     The task for now is to refine logics of both wait instructions.
#     Since the rc-service jaisocx-http restart | stop | start did not have the normal flow in this Dockerfile variant,
#     and the Aim of the Setup was primarily, under Alpine platform 
#     to register services normally as designed by openrc and advised by Alpine.






### decomment (A), when with TRAP and WAIT feature,
###    in order to achieve OpenRC services restart | stop | start feature
###    when logged into docker service ( docker compose exec [ -u <user> ] app_via_image bash )

# # if [[ "${LOGGED_IN_USERNAME}" != "${USER_NAME}" ]]; then
# A. #   openrc "default"
#   # rc-service "${JSC_IMAGE_SERVICE_NAME}" restart
# A. #  export pid1=$!
#   # read -r pid1 < "/run/pid"
# # fi

# A. # trap "echo \"Shutting down...\"; kill -9 $pid1 $pid2; wait $pid1 $pid2" SIGINT SIGTERM SIGHUP





# logged service start date and time

if [[ "${LOGGED_IN_USERNAME}" == "${USER_NAME}" && "${container_builds}" == "true" ]]; then

  export TZ="GMT"
  log_entry_jaisocx_service_start="${JSC_IMAGE_SERVICE_NAME}_built=\"$(date | xargs)\""
  echo -e "${log_entry_jaisocx_service_start}" >> "${file_image_service_start_markers_in_log_folder}.log"
  echo -e "${log_entry_jaisocx_service_start}" > "${file_image_service_start_markers_in_log_folder}"
  echo -e "HAVE_TO_RESTART after was built now: ${log_entry_jaisocx_service_start}" >> "${file_image_markers_in_log_folder}"


  export TZ="${TIME_ZONE}"
  log_entry_jaisocx_service_start="${JSC_IMAGE_SERVICE_NAME}_built=\"$(date | xargs)\""
  echo -e "${log_entry_jaisocx_service_start}" >> "${file_image_service_start_markers_in_log_folder}.log"
  echo -e "${log_entry_jaisocx_service_start}" >> "${file_image_service_start_markers_in_log_folder}"
  echo -e "HAVE_TO_RESTART after was built now: ${log_entry_jaisocx_service_start}" >> "${file_image_markers_in_log_folder}"


  exec "$@"


else

  export TZ="GMT"
  log_entry_jaisocx_service_start="${JSC_IMAGE_SERVICE_NAME}=\"$(date | xargs)\""
  echo -e "${log_entry_jaisocx_service_start}" >> "${file_image_service_start_markers_in_log_folder}.log"
  echo -e "${log_entry_jaisocx_service_start}" > "${file_image_service_start_markers_in_log_folder}"

  export TZ="${TIME_ZONE}"
  log_entry_jaisocx_service_start="${JSC_IMAGE_SERVICE_NAME}=\"$(date | xargs)\""
  echo -e "${log_entry_jaisocx_service_start}" >> "${file_image_service_start_markers_in_log_folder}.log"
  echo -e "${log_entry_jaisocx_service_start}" >> "${file_image_service_start_markers_in_log_folder}"

fi







# Openrc conf according to 2. backgroundmode=false
# FOREGROUND
#    after ( openrc "default" )
#       NO entrypoint.sh code lines are done.
#       docker service serves the sites on the SitesServer.
#       
openrc "default"



### decomment (B), when with TRAP and WAIT feature,
###    in order to achieve OpenRC services restart | stop | start feature
###    when logged into docker service ( docker compose exec [ -u <user> ] app_via_image bash )


### TRAP and WAIT feature

# B. # tail -f < /dev/null &
# B. # pid2=$!
# B. # trap "echo \"Shutting down...\"; kill -9 $pid1 $pid2; wait $pid1 $pid2" SIGINT SIGTERM SIGHUP

# B. # wait $pid1
# B. # wait $pid2






