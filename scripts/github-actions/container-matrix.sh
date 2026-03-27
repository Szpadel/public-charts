#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <base-sha> <head-sha>" >&2
  exit 1
fi

base_sha="$1"
head_sha="$2"

list_all_container_paths() {
  find containers -mindepth 1 -maxdepth 1 -type d \
    | while read -r container_dir; do
        if [[ -f "${container_dir}/Dockerfile" ]]; then
          basename "${container_dir}"
        fi
      done \
    | sort -u
}

if [[ -n "${base_sha}" && ! "${base_sha}" =~ ^0+$ ]]; then
  if ! git rev-parse --verify "${base_sha}^{commit}" >/dev/null 2>&1; then
    base_sha=""
  fi
fi

if [[ -z "${base_sha}" || "${base_sha}" =~ ^0+$ ]]; then
  if git rev-parse "${head_sha}^" >/dev/null 2>&1; then
    base_sha="$(git rev-parse "${head_sha}^")"
  else
    base_sha="$(git hash-object -t tree /dev/null)"
  fi
fi

if git diff --name-only "${base_sha}" "${head_sha}" -- \
  .github/workflows/build_and_push_containers.yml \
  scripts/github-actions \
  | grep -q .; then
  mapfile -t container_paths < <(list_all_container_paths)
else
  mapfile -t container_paths < <(
    git diff --name-status "${base_sha}" "${head_sha}" -- containers \
      | awk '$1 != "D"' \
      | awk '{if ($3 != "") print $3; else print $2}' \
      | awk -F/ '{print $2}' \
      | sort -u
  )
fi

if [[ ${#container_paths[@]} -eq 0 ]]; then
  echo 'has_changes=false'
  echo 'matrix={"container_path":[]}'
  exit 0
fi

matrix="$(
  printf '%s\n' "${container_paths[@]}" \
    | jq -R . \
    | jq -cs '{container_path: .}'
)"

echo 'has_changes=true'
echo "matrix=${matrix}"
