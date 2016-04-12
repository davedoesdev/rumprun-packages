#!/bin/bash
# usage: push.sh <repo-name> <version> <file>
publish_dir="$(dirname "$0")/publish/$1"
mkdir -p "$publish_dir"
cp "$3" "$publish_dir/$2-$RUMPRUN_TOOLCHAIN_TUPLE-$RUMPRUN_PUBLISH_CONFIG"
