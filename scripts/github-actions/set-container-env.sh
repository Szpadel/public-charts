#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <container-path>" >&2
  exit 1
fi

if [[ -z "${GITHUB_ENV:-}" ]]; then
  echo "GITHUB_ENV must be set" >&2
  exit 1
fi

container_path="$1"
image_owner="${GITHUB_REPOSITORY_OWNER,,}"

{
  echo "IMAGE_OWNER_LOWER=${image_owner}"
  echo "IMAGE_NAME=${REGISTRY:?}/${image_owner}/${container_path}"
  echo "VERSION=$(cat "containers/${container_path}/VERSION")"
} >> "${GITHUB_ENV}"
