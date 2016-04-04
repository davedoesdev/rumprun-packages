#!/bin/sh
set -e
if [ -z "$1" ]; then
  echo "No package specified"
  exit 1
fi
apt-get update -y && apt-get install -y curl
cd "$(dirname "$0")/.."
echo "RUMPRUN_TOOLCHAIN_TUPLE=$RUMPRUN_TOOLCHAIN_TUPLE" > config.mk
cd "$1"
make -j2
