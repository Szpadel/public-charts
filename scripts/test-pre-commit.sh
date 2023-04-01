#!/usr/bin/env bash
set -euo pipefail

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")../"

if command -v pre-commit &>/dev/null;then
    if ! [ -f "$DIR/.git/hooks/pre-commit" ];then
        pre-commit install
    fi
    pre-commit run -a
fi
