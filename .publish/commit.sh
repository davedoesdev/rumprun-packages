#!/bin/bash
# usage: commit.sh
publish_dir="$(dirname "$0")/publish"
mkdir -p "$publish_dir"
cd "$publish_dir"
for a in *; do
  if [ -d "$a" ]; then
    echo "$a"
    tar -Jcf "../$a.tar.xz" -C "$a" .
  fi
done
