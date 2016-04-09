#!/bin/bash
free -m
set -e
if [ -z "$1" ]; then
  echo "No package specified"
  exit 1
fi
. ~/.nvm/nvm.sh
cd "$(dirname "$0")/.."
echo "RUMPRUN_TOOLCHAIN_TUPLE=$RUMPRUN_TOOLCHAIN_TUPLE" > config.mk
cd "$1"
make
