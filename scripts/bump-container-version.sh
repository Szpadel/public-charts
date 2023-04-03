#!/usr/bin/env bash
set -euo pipefail
DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../"
cd "$DIR"

if [ "$#" != 1 ];then
  echo "Usage: $0 <container-name>"
  exit 1
fi

IFS='.' read -ra verArray <<< "$(cat containers/$1/VERSION)"
newVer="${verArray[0]}.${verArray[1]}.$(( verArray[2] + 1 ))"
echo "Updating version of $1 to $newVer"
echo "$newVer" > containers/$1/VERSION
