FROM alpine:3.21.3

USER root

## shows the echo lines when building this image
RUN set -x

## allows instruction "source <file>" and later ARG variables binding from the imported file
RUN set -a



### --------------------------
### BUILD BY DOCKER BUILDX FOR SEVERAL ARCHITECTURES
### ==========================

# Importing from the Docker Buildx build
# These args are used by Docker Buildx.
# example value obtained for TARGETPLATFORM: linux/amd64
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

RUN echo "Building for the target architecture: ${TARGETPLATFORM}"





### --------------------------
### Build time DOCKER BUILDX BUILD --build-arg USER_NAME="${USER_NAME}" ASSIGNED ENVIRONMENT VARIABLES from .env 
### ==========================

### docker buildx build --build-arg, these are fest in printenv
# ARG TIME_ZONE
# ARG LOGGED_IN_USERNAME
# ARG VOLUME_PATH

### docker-compose.yml
# ARG TIME_ZONE

# ARG GROUP_SUDIERS_NAME
# ARG GROUP_USERS_NAME
# ARG USER_SUDIER_NAME
# ARG USER_NAME
# ARG LOGGED_IN_USERNAME

# ARG VOLUME_PATH


### .env and not in the current ver. or the docker-compose.yml file

ARG JSC_IMAGE_NAME
ARG JSC_IMAGE_SERVICE_NAME

ARG TIME_ZONE

ARG ROOT_HASHED_PWD

ARG GROUP_SUDIERS_ID
ARG GROUP_SUDIERS_NAME
ARG GROUP_USERS_ID
ARG GROUP_USERS_NAME
ARG USER_SUDIER_ID
ARG USER_SUDIER_NAME
ARG USER_SUDIER_HASHED_PWD
ARG USER_ID
ARG USER_NAME
ARG LOGGED_IN_USERNAME

ARG VOLUME_PATH


### SETTINGS FOR LIBRARIES AND PACKAGES TO INSTALL
ARG APPLY_SUDIERS_AND_PASSWORDS
ARG INSTALL_BASH
ARG INSTALL_TZDATA
ARG INSTALL_CURL
ARG INSTALL_OPENRC
ARG INSTALL_JAVA
ARG INSTALL_NODE
ARG INSTALL_PHP

ARG JAVA_LIBRARY_NAME

ARG CACHE






### ENV VARIABLES DECLARE
ENV TZ="${TIME_ZONE}"


### temporary local ARGs and Constants
ARG const_sh_file_first_line="#!/usr/bin/env sh"




### PATHS 

## PATHS HARDCODED TO LOOKUP
# ARG folder_image_settings_linux      = "/etc"
# ARG folder_image_settings            = "/etc/jsc_image"
# ARG folder_image_settings_env        = "/etc/jsc_image/settings"
# ARG folder_image_settings_commands   = "/etc/jsc_image/commands"

ARG folder_image_settings_linux="/etc"
ARG folder_image_settings="${folder_image_settings_linux}/${JSC_IMAGE_NAME}"
ARG folder_image_settings_env="${folder_image_settings_linux}/${JSC_IMAGE_NAME}/settings"
ARG folder_image_settings_commands="${folder_image_settings_linux}/${JSC_IMAGE_NAME}/commands"
ARG folder_image_settings_markers="${folder_image_settings_linux}/${JSC_IMAGE_NAME}/markers"



## PATHS HARDCODED TO LOOKUP
# ARG file_env_copy          = "/etc/jsc_image/settings/.env"
# ARG file_env_current_allow = "/etc/jsc_image/settings/env.current.allow"
# ARG file_env_current       = "/etc/jsc_image/settings/env.current"
# ARG file_env_temp          = "/etc/jsc_image/settings/env.temp"

ARG file_env_host="./.env"
ARG file_env_current_allow_host="./env.current.allow"

ARG file_env_copy="${folder_image_settings_env}/.env"
ARG file_env_current_allow_copy="${folder_image_settings_env}/env.current.allow"
ARG file_env_current="${folder_image_settings_env}/env.current"
# ARG file_env_temp="${folder_image_settings_env}/env.temp"
ARG file_env_entry_template="${folder_image_settings_env}/env.entry.template"
ARG file_env_entry="${folder_image_settings_env}/env.entry"

ARG file_image_markers="${folder_image_settings_markers}/build_status"






### --------------------------
### FILESYSTEM FOR VOLUMES TO MOUNT
### ==========================

### PATHS 

## PATHS HARDCODED TO LOOKUP
# ARG folder_image_mounted_software="/usr/lib/jsc_image"
# ARG folder_image_mounted_software_jsc_image_service="/usr/lib/jsc_image/jaisocx-http"
# ARG folder_image_mounted_data="/var/data/jsc_image"
# ARG folder_image_mounted_logs="/var/log/jsc_image"


ARG folder_image_mounted_software="/usr/lib/${JSC_IMAGE_NAME}"
ARG folder_image_mounted_software_jsc_image_service="/usr/lib/${JSC_IMAGE_SERVICE_NAME}"
ARG folder_image_mounted_data="/var/data/${JSC_IMAGE_NAME}"
ARG folder_image_mounted_logs="/var/log/${JSC_IMAGE_NAME}"
ARG folder_image_mounted_logs_jsc_image_service="${folder_image_mounted_logs}/${JSC_IMAGE_SERVICE_NAME}"

ARG file_image_markers_in_log_folder="${folder_image_mounted_logs_jsc_image_service}/build_status"
ARG file_image_service_start_markers_in_log_folder="${folder_image_mounted_logs_jsc_image_service}/service_started"







### --------------------------
### grants in docker on filesystem 
#### This umask (027) balances security and usability:
#### Directories: 750 (rwxr-x---)
#### Files: 640 (rw-r-----)
### ==========================
# RUN echo -e "\umask 027\n\n\n" >> "/etc/profile"




### --------------------------
### FILESYSTEM FOR FILES TO COPY
### ==========================

## create folders in docker fs
RUN mkdir -p "${folder_image_settings_env}"
RUN mkdir    "${folder_image_settings_commands}"
RUN mkdir    "${folder_image_settings_markers}"


RUN chmod -R u+rwx "${folder_image_settings}"
RUN chmod -R g+rwx "${folder_image_settings}"
# RUN chmod -R o-rwx "${folder_image_settings}"


COPY "${file_env_host}" "${file_env_copy}"
COPY "${file_env_current_allow_host}" "${file_env_current_allow_copy}"
COPY "./dockerfile_copy/templates/env.entry.template" "${file_env_entry_template}"
COPY "./dockerfile_copy/commands/entrypoint.sh" "${folder_image_settings_commands}/entrypoint.sh"

RUN touch "${file_env_current}"
# RUN touch "${file_env_temp}"
RUN touch "${file_env_entry}"


RUN chmod -R u+rwx "${folder_image_settings_env}"
RUN chmod -R g+rwx "${folder_image_settings_env}"
RUN chmod -R o+r   "${folder_image_settings_env}"
RUN chmod -R o-wx  "${folder_image_settings_env}"

RUN chmod -R u+rwx "${folder_image_settings_commands}"
RUN chmod -R g+rwx "${folder_image_settings_commands}"
RUN chmod -R o+rx  "${folder_image_settings_commands}"

RUN chmod -R u+rwx "${folder_image_settings_markers}"
RUN chmod -R g+rwx "${folder_image_settings_markers}"
RUN chmod -R o+rwx "${folder_image_settings_markers}"


RUN touch          "${file_image_markers}"
RUN chmod -R u+rw  "${file_image_markers}"
RUN chmod -R g+rw  "${file_image_markers}"
RUN chmod -R o+rw  "${file_image_markers}"



### --------------------------
### INSTALLL PACKAGES FOR GROUPS, USERS AND PASSWORDS
### ==========================

RUN <<EOF

  set -a
  source "${file_env_copy}"

  if [[ "${APPLY_SUDIERS_AND_PASSWORDS}" == "true" ]]; then
    apk add sudo
    apk add shadow
  fi

  set +a

EOF





### --------------------------
### Users and Groups
### ==========================

RUN addgroup -g "${GROUP_USERS_ID}" "${GROUP_USERS_NAME}"
RUN addgroup -g "${GROUP_SUDIERS_ID}" "${GROUP_SUDIERS_NAME}"

RUN adduser  -u "${USER_ID}" -D -G "${GROUP_USERS_NAME}" "${USER_NAME}"

RUN adduser  -u "${USER_SUDIER_ID}" -D -G "${GROUP_SUDIERS_NAME}" "${USER_SUDIER_NAME}"
RUN addgroup    "${USER_SUDIER_NAME}" "${GROUP_USERS_NAME}"
  


### SUDIERS USERS AND GROUPS 
### ==========================


ARG sudoers_file_name="/etc/sudoers.d/${GROUP_SUDIERS_NAME}"
RUN touch "${sudoers_file_name}"
RUN chmod u+rw "${sudoers_file_name}"

## USE FUNC ARRAY JOIN(): # echo_lines = ( "\n" "# The custom group in this test image" "\n" "%${GROUP_SUDIERS_NAME} ALL=(ALL) ALL" "\n" )
RUN echo -e "# The custom group in this test image\n%${GROUP_SUDIERS_NAME} ALL=(ALL) ALL\n\n" >> "${sudoers_file_name}"

## NOT TESTED # GRANTED INVOKE COMMANDS e.g. java, rc-service, apk
## USE FUNC ARRAY JOIN(): # echo_lines = ( "%${GROUP_SUDIERS_NAME} ALL=" "/usr/bin/less" ", " "/usr/bin/apt" "\n" )
# echo -e "%${GROUP_SUDIERS_NAME} ALL=/usr/bin/less, /usr/bin/apt" >> "${sudoers_file_name}"

RUN chmod 440 "${sudoers_file_name}"




### --------------------------
### sudoers users passwords ### lib shadow
### ==========================

RUN <<EOF  

  set -a
  source "${file_env_copy}"

  if [[ "${APPLY_SUDIERS_AND_PASSWORDS}" == "true" ]]; then
    echo "root:${ROOT_HASHED_PWD}" | chpasswd -e
    echo "${USER_SUDIER_NAME}:${USER_SUDIER_HASHED_PWD}" | chpasswd -e
    # echo "${USER_SUDIER_NAME}:${USER_SUDIER_PWD}" | chpasswd
  fi

  set +a

EOF



RUN mkdir -p       "${folder_image_mounted_software}"
RUN mkdir -p       "${folder_image_mounted_software_jsc_image_service}"
RUN mkdir -p       "${folder_image_mounted_data}"
RUN mkdir -p       "${folder_image_mounted_logs}"

# RUN chown -R       "${USER_SUDIER_NAME}:${GROUP_USERS_NAME}" "${folder_image_mounted_software_jsc_image_service}"
# RUN chown -R       "${USER_SUDIER_NAME}:${GROUP_USERS_NAME}" "${folder_image_mounted_data}"
# RUN chown -R       "${LOGGED_IN_USERNAME}:${GROUP_USERS_NAME}" "${folder_image_mounted_logs}"



RUN chmod -R u+rwx "${folder_image_mounted_software_jsc_image_service}"
RUN chmod -R g+rwx "${folder_image_mounted_software_jsc_image_service}"

RUN chmod -R u+rwx "${folder_image_mounted_data}"
RUN chmod -R g+rwx "${folder_image_mounted_data}"

RUN chmod -R u+rwx "${folder_image_mounted_logs}"
RUN chmod -R g+rwx "${folder_image_mounted_logs}"



### --------------------------
### # chown after users and groups created
### ==========================

RUN chown -R       "${LOGGED_IN_USERNAME}:${GROUP_USERS_NAME}" "${folder_image_settings_env}"
RUN chown -R       "${LOGGED_IN_USERNAME}:${GROUP_USERS_NAME}" "${folder_image_settings_commands}"






### --------------------------
### INSTALLL PACKAGES 
### ==========================

# RUN apk add   sudo   # for users and groups, access level secured with passwords prompts. 
# RUN apk add   shadow # for users and groups, secure methods to set passwords
# RUN apk add   bash
# RUN apk add   tzdata # formatting date with timezone set via ENV TZ="Europe/Zurich"
# RUN apk add   curl
# RUN apk add   coreutils
# RUN apk add   util-linux
# RUN apk add   openrc # services for alpine, start restart, stop.



RUN <<EOF
  ## allows instruction "source <file>" and later ARG variables binding from the imported file
  set -a
  source "${file_env_copy}"

  if [[ "${INSTALL_BASH}" == "true" ]]; then
    apk add   bash
    # apk add   bash zsh 
    # apk add   cmd:bash cmd:zsh 
  fi

  if [[ "${INSTALL_OPENRC}" == "true" ]]; then
    apk add   coreutils
    apk add   util-linux
    apk add   openrc
  fi

  if [[ "${INSTALL_TZDATA}" == "true" ]]; then
    apk add   tzdata
  fi

  # if [[ "${INSTALL_CURL}" == "true" ]]; then
  #   apk add   curl
  # fi

  # if [[ "${INSTALL_NODE}" == "true" ]]; then
  #   apk add   curl
  # fi

  # if [[ "${INSTALL_PHP}" == "true" ]]; then
  #   # apk add bash
  # fi


  set +a

EOF




# ### --------------------------
# ### ACCORDING TO ARCHITECTURE, INSTALL LIBRARIES
# ### ==========================

# ### --------------------------
# ### get Alpine Community Repo url
# ### ==========================


# ##### NOT TESTED
# ##### IN DEVELOPMENT


# RUN <<EOF
#   source "${LOCAL_ALPINE_FUNC_PATH}"
#   ALPINE_COMMUNITY_URL="$(get_alpine_url "${TARGETPLATFORM}")"
#   ALPINE_COMMUNITY_RELEASE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.21/community/${ALPINE_COMMUNITY_URL}"

#   # erases the file and writes new line
#   echo "ALPINE_COMMUNITY_URL=\"${ALPINE_COMMUNITY_URL}\"" > "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"

#   # adds other new line
#   echo "ALPINE_COMMUNITY_RELEASE_URL=\"${ALPINE_COMMUNITY_RELEASE_URL}\"" >> "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"

#   # echo for the preview in docker logs
#   echo "${ALPINE_COMMUNITY_URL}"
#   # echo "ALPINE_COMMUNITY_RELEASE_URL=${ALPINE_COMMUNITY_RELEASE_URL}"
# EOF








### --------------------------
### Install based on architecture
### INSTALL JAVA
### ==========================


RUN <<EOF

  set -a
  source "${file_env_copy}"
  
  INSTALL_LIBRARY="${INSTALL_JAVA}"
  LIBRARY_NAME="${JAVA_LIBRARY_NAME}"

  if [[ "${INSTALL_LIBRARY}" == "true" ]]; then

    ### FOR NOW THE FUNCTION IS NOT BEING IMPORTED
    # source "${LOCAL_ENV_LIKE_TMP_FILE_PATH}"
    
    repo_url="https://dl-cdn.alpinelinux.org/alpine/v3.21/community/"
    apk add "${LIBRARY_NAME}" $CACHE --repository="${repo_url}"

    # apk add "${LIBRARY_NAME}" --repository="${ALPINE_COMMUNITY_RELEASE_URL}" || \
    #     (echo "No suitable ${LIBRARY_NAME} version found for ${TARGETPLATFORM} on Alpine url community/${ALPINE_COMMUNITY_URL}" && exit 1)

  fi

  set +a

EOF







### --------------------------
### Install based on architecture
### INSTALL NVM, NODE, NPM, YARN
### ==========================

### --------------------------
### Install based on architecture
### 1. INSTALL NVM
### ==========================

##### NOT TESTED

# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# ENV NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# RUN <<EOF

#   if [[ "${INSTALL_NODE}" == "true" ]]; then

#     apk add bash
#     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
#     NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#     echo "NVM_DIR=\"${NVM_DIR}\"" >> "/etc/profile"

#   fi

# EOF


RUN mkdir -p    "/run/openrc"
RUN touch       "/run/openrc/softlevel"
RUN chown -R    "${USER_SUDIER_NAME}:${GROUP_USERS_NAME}" "/run/openrc" 
RUN chmod u+rwx "/run/openrc"
RUN chmod g+rwx "/run/openrc"
RUN chmod o+r   "/run/openrc"
# RUN chmod o-rwx "/run/openrc"

RUN touch       "/run/pid"
RUN chown       "${USER_SUDIER_NAME}:${GROUP_USERS_NAME}" "/run/pid"
RUN chmod u+rwx "/run/pid"
RUN chmod g+rw  "/run/pid"
RUN chmod o+rw  "/run/pid"
RUN chmod g-x   "/run/pid"


RUN touch        "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}"
RUN chown        "${USER_SUDIER_NAME}:${GROUP_USERS_NAME}" "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}" 
RUN chmod u+rwx  "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}" 
RUN chmod g+rx   "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}" 
RUN chmod o+rx   "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}" 
RUN chmod g-w    "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}" 
RUN chmod o-w    "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}" 





RUN <<EOF

  set -a
  source "${file_env_copy}"
  
  if [[ "${INSTALL_OPENRC}" == "true" ]]; then
    line1="#!/sbin/openrc-run"
    line2="name=\"Jaisocx Sites Server\""
    line3="description=\"Serves Endpoints to deliver Sites contents to Browsers and Networking Clients\""
    line4="command=\"${folder_image_mounted_software_jsc_image_service}/cmd-linux/server-run.sh\""
    line6="command_background=false"
    line7="pidfile=\"/run/pid\""

    echo  -e     "${line1}\n${line2}\n${line3}\n${line4}\n${line5}\n${line6}\n${line7}\n\n\n" > "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}"

  else
    rm "/etc/init.d/${JSC_IMAGE_SERVICE_NAME}"
    rm -rf "/run/openrc"
    rm "/run/pid"
  fi

  set +a
  
EOF



### ENV to register in entrypoint.sh for users when entered docker service
RUN <<EOF

  set -a
  source "${file_env_copy}"

  echo -e " " > "${file_env_current}"
  chmod u+x "${file_env_current}"
  chmod g+x "${file_env_current}"

  while IFS=$'\n' read -r cy_env_entry_line; do

    variable_name="$(echo "${cy_env_entry_line}" | cut -d"=" -f1 | xargs)"
    eval "variable_value=\"\$${variable_name}\""
    env_entry_line="${variable_name}=\"${variable_value}\""
    echo -e "${env_entry_line}" >> "${file_env_current}"

  done < "${file_env_current_allow_copy}"

  set +a

EOF




### ENV to read in entrypoint.sh
RUN <<EOF

  set -a
  source "${file_env_copy}"

  echo -e " " > "${file_env_entry}"
  chmod u+x "${file_env_entry}"
  chmod g+x "${file_env_entry}"

  while IFS=$'\n' read -r cy_env_entry_line; do

    variable_name="$(echo "${cy_env_entry_line}" | cut -d"=" -f1 | xargs)"
    if [[ -z "${variable_name}" ]]; then
      continue
    fi

    eval "variable_value=\"\$${variable_name}\""
    env_entry_line="${variable_name}=\"${variable_value}\""
    echo -e "${env_entry_line}" >> "${file_env_entry}"

  done < "${file_env_entry_template}"

  ls -la "${file_env_entry}"
  cat "${file_env_entry}"

  set +a

EOF

RUN ls -la "${file_env_entry}"
RUN cat "${file_env_entry}"




RUN <<EOF

  # jaisocx_rc_service_marker=""

  # if [ -x "${file_image_markers_in_log_folder}" ]; then
  #   export jaisocx_rc_service_marker="$(cat "${file_image_markers_in_log_folder}" | grep "${JSC_IMAGE_SERVICE_NAME}")"
  # else
    echo "container_builds=\"true\"" >> "${file_image_markers}"
    echo "container_builds=\"true\"" >> "${file_env_entry}"
  # fi

  # if [[ -z "${jaisocx_rc_service_marker}" ]]; then

    echo -e "#!/sbin/openrc-run\nexit 0" > /etc/init.d/hwdrivers
    chmod +x /etc/init.d/hwdrivers

    echo -e "#!/sbin/openrc-run\nexit 0" > /etc/init.d/machine-id
    chmod +x /etc/init.d/machine-id


    rc-update add "${JSC_IMAGE_SERVICE_NAME}" default

  # fi

EOF



# USER "${USER_SUDIER_NAME}"

# RUN <<EOF

#   jaisocx_rc_service_marker=""
#   if [ -x "${file_image_markers_in_log_folder}" ]; then
#     export jaisocx_rc_service_marker="$(cat "${file_image_markers_in_log_folder}" | grep "${JSC_IMAGE_SERVICE_NAME}")"
#   fi

#   if [[ -n "${jaisocx_rc_service_marker}" && "${jaisocx_rc_service_marker}" == "${JSC_IMAGE_SERVICE_NAME}" ]]; then
#     openrc "default"
#   fi

# EOF

RUN rm "${file_env_copy}"


# VOLUME [ "./software/jaisocx-http", "${folder_image_mounted_software_jsc_image_service}" ]
# VOLUME [ "./data", "${folder_image_mounted_data}" ]
# VOLUME [ "./log", "${folder_image_mounted_logs}" ]



USER       "${LOGGED_IN_USERNAME}"

WORKDIR    "${folder_image_mounted_data}"

ENTRYPOINT [ "/etc/jsc_image/commands/entrypoint.sh", "/etc/jsc_image/settings/env.entry", "/etc/jsc_image/settings/env.current" ]





