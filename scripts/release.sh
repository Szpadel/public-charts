#!/usr/bin/env bash
set -euo pipefail
DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../"
cd "$DIR"

URL=https://szpadel.github.io/library-charts/

bump_version() {
  local path=$1
  local version major minor patch
  version=$(grep '^version:' "$path/Chart.yaml" | awk '{print $2}')
  major=$(echo $version | cut -d. -f1)
  minor=$(echo $version | cut -d. -f2)
  patch=$(echo $version | cut -d. -f3)
  if [ "$BUMP_PATCH" = "1" ];then
    patch=$(expr $patch + 1)
  fi
  if [ "$BUMP_MINOR" = "1" ];then
    patch=0
    minor=$(expr $minor + 1)
  fi
  echo "Replacing $version with $major.$minor.$patch"
  sed -i "s/^version:.*/version: ${major}.${minor}.${patch}/g" "$path/Chart.yaml"
}

run() {
  local chart=$1

  if [ "$ALPINE_INSTALL" = "1" ];then
    alpine_install_deps
  fi

  if [ "$BUMP_MINOR" = "1" ] || [ "$BUMP_PATCH" = "1" ];then
    bump_version "charts/$chart"
  fi
  helm package "charts/$chart" -d releases/

  helm repo index --merge index.yaml --url "$URL" .
  if [ -n "$CHOWN" ];then
    chown -R "$CHOWN" releases index.yaml
  fi
}

alpine_install_deps() {
  apk add --no-cache helm gawk sed
}


ALPINE_INSTALL=0
BUMP_MINOR=0
BUMP_PATCH=0
POSITIONAL_ARGS=()
CHOWN=
while [[ $# -gt 0 ]]; do
  case $1 in
    --bump-minor)
      BUMP_MINOR=1
      shift
      ;;
    --bump-patch)
      BUMP_PATCH=1
      shift
      ;;
    --alpine-install-deps)
      ALPINE_INSTALL=1
      shift
      ;;
    --chown)
      CHOWN=$2
      shift
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

if [ "${#POSITIONAL_ARGS[@]}" != 1 ];then
  echo "Usage: $0 <chart name>"
  exit 1
fi

run "${POSITIONAL_ARGS[@]}"
