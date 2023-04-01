#!/usr/bin/env bash
set -euo pipefail
OWN="$(realpath "${BASH_SOURCE[0]}")"
DIR="$(dirname "$OWN")"
ROOT="$DIR/../"

DOCKER_SOCKET="${DOCKER_SOCKER:-/run/docker.sock}"

help() {
  echo "--run-in-docker         Reexec itself inside docker"
  echo "--alpine-install-deps   Install dependencies inside alpine"
}

# Doesn't work for empty array
escape_arr() {
  local arr_name=$1 arr_name2="$1[@]"
  readarray -t -d '' $arr_name < <(printf "%q\0" "${!arr_name2}")
}

run_in_docker() {
  local args=("$@")
  if [ "${#args[@]}" -gt "0" ];then
    escape_arr args
  fi

  docker run --rm -it \
    -v "$DOCKER_SOCKET:/run/docker.sock" \
    -v "$ROOT:$ROOT" \
    -w "$ROOT" alpine \
    sh -c "apk add bash && '$OWN' --alpine-install-deps ${args[*]}"
  exit 0
}

install_alpine_deps() {
  apk add --no-cache docker-cli curl
  (
    curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s -- -b /usr/local/bin/
  )
}

run() {
  act \
    -P ubuntu-latest=catthehacker/ubuntu:act-latest \
    -P ubuntu-22.04=catthehacker/ubuntu:act-22.04 \
    -P ubuntu-20.04=catthehacker/ubuntu:act-20.04 \
    -P ubuntu-18.04=catthehacker/ubuntu:act-18.04 \
   "$@"
}

POSITIONAL_ARGS=()
ALPINE_INSTALL=0
RUN_IN_DOCKER=0
while [[ $# -gt 0 ]]; do
  case $1 in
    --run-in-docker)
      RUN_IN_DOCKER=1
      shift
      ;;
    --alpine-install-deps)
      ALPINE_INSTALL=1
      shift
      ;;
    --*|-*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

if [ "$RUN_IN_DOCKER" = "1" ];then
  run_in_docker "${POSITIONAL_ARGS[@]}"
elif [ "$ALPINE_INSTALL" = "1" ];then
  install_alpine_deps
  run "${POSITIONAL_ARGS[@]}"
else
  run "${POSITIONAL_ARGS[@]}"
fi
