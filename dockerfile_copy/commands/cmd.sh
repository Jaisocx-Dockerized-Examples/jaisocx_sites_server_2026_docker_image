#!/usr/bin/env bash

set    -xea



ENV_FILE="$1"
source "${ENV_FILE}"



echo "$(date | xargs) command as $(id)" >> "/var/log/jaisocx/installations_markers"


exec "$@"



tail -f < /dev/null &
pid1=$! 
trap "echo \"Stops ...\"; kill $pid1 $pid2; wait $pid1 $pid2" SIGINT SIGTERM



tail -f < /dev/null &
pid2=$!
trap "echo \"Stops ...\"; kill $pid1 $pid2; wait $pid1 $pid2" SIGINT SIGTERM







printenv

# source "${ENV_FILE}"

# installations_markers_path="${MAPPED_VOL_LOG}/${jaisocx_service_keyword}/installations_markers"
# echo "$(date | xargs) Entered Cmd as $(id); LOGGED_IN_USERNAME: ${LOGGED_IN_USERNAME}" >> "${installations_markers_path}"




# export  service_start_markers_path="${MAPPED_VOL_LOG}/${jaisocx_service_keyword}/service_start"
# export  jaisocx_service_start="$(date | xargs)"
# export  log_entry_jaisocx_service_start="${jaisocx_service_keyword}=\"${jaisocx_service_start}\""
# echo    -e       "${log_entry_jaisocx_service_start}" >> "${service_start_markers_path}.log"
# echo             "${log_entry_jaisocx_service_start}" > "${service_start_markers_path}"





  # if [ $# -eq 0 ]; then
  #   # No command passed, start interactive shell as 'user'
  #   exec
  # else
  #   # Command passed — run it as 'user'
  #   exec su - "${LOGGED_IN_USERNAME}" -c "$@"
  # fi



# exec "$@"

wait $pid1
wait $pid2


