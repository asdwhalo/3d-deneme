#!/bin/sh
printf '\033c\033]0;%s\a' 3d deneme
base_path="$(dirname "$(realpath "$0")")"
"$base_path/3d preprealpha.x86_64" "$@"
