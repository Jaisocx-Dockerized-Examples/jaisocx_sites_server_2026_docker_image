#!/bin/bash

# For options that take a <size> parameter,
# suffix the number with "k" or "K" to indicate kilobytes,
# "m" or "M" to indicate megabytes,
# or "g" or "G" to indicate gigabytes.

# -Xms set initial Java heap size
START_MEMORY_HEAP_SIZE=64m

# -Xmx set maximum Java heap size. If your jre runs out of memory, increase this parameter please
MAX_MEMORY_HEAP_SIZE=4g


#--------------------------------------------------------------------------------
# PARAMS FINISH
#================================================================================


#--------------------------------------------------------------------------------
# DON'T EDIT HERE
#--------------------------------------------------------------------------------
cd "/usr/lib/jaisocx-http"


start_mem="-Xms${START_MEMORY_HEAP_SIZE}"
max_mem="-Xmx${MAX_MEMORY_HEAP_SIZE}"


# sudo -- bash -c 'export PHP_FPM_HOST="localhost:9090"; java $start_mem $max_mem -jar "out/artifacts/jaisocx_http_jar/jaisocx-http.jar"'
java "${start_mem}" "${max_mem}" -jar "out/artifacts/jaisocx_http_jar/jaisocx-http.jar"


