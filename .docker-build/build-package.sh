#!/bin/sh
set -e
if [ -z "$1" ]; then
  echo "No package specified"
  exit 1
fi
# install dependencies needed by packages but not by toolchain
apk add --update tar patch
cd "$(dirname "$0")/.."
echo "RUMPRUN_TOOLCHAIN_TUPLE=$RUMPRUN_TOOLCHAIN_TUPLE" > config.mk
cd "$1"
make -j2
