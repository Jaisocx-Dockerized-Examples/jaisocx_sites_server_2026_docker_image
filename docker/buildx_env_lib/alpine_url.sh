#!/usr/bin/env sh

get_alpine_url() {
  local platform="$1"
  local ret_val=""

  case "${platform}" in
    "linux/amd64")    ret_val="x86_64" ;;
    "linux/arm/v6")   ret_val="armhf" ;;
    "linux/arm/v7")   ret_val="armv7" ;;
    "linux/arm64")    ret_val="aarch64" ;;
    "linux/386")      ret_val="x86" ;;
    "linux/ppc64le")  ret_val="ppc64le" ;;
    "linux/riscv64")  ret_val="riscv64" ;;
    "linux/s390x")    ret_val="s390x" ;;
    *)                ret_val="unsupported" ;;
  esac

  echo "${ret_val}"
}

