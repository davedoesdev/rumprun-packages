#!/bin/bash
# usage: commit.sh
publish_dir="$(dirname "$0")/publish"
mkdir -p "$publish_dir"
cd "$publish_dir"
for d in *; do
  if [ -d "$d" ]; then
    echo "$d"
    tar -Jcf "../$d.tar.xz" "$d"
  fi
done
