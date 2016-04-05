#!/bin/bash
cd "$(dirname "$0")"
image="${2:-davedoesdev/rumprun-toolchain-x86_64-rumprun-netbsd-hw}"
exec docker run --rm=true -e "BUILD_TAG=$BUILD_TAG" -v "$PWD/..:/rumprun-packages" "$image" "$1"
