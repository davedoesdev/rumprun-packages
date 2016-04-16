#!/bin/bash
# usage: push.sh <repo-name> <version> <file>
#        push.sh <repo-name>/<dest> <file>
dest="$(dirname "$0")/publish/$1"
if [ $# -eq 3 ]; then
  dest+="/$2-$RUMPRUN_TOOLCHAIN_TUPLE-$RUMPRUN_PUBLISH_CONFIG"
  file="$3"
else
  file="$2"
fi
mkdir -p "$(dirname "$dest")"
cp "$file" "$dest"
