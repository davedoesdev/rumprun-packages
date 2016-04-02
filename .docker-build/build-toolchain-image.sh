#!/bin/bash
cd "$(dirname "$0")"
tuple="${1:-x86_64-rumprun-netbsd}"
platform="${2:-hw}"
docker build -f Dockerfile.toolchain -t "davedoesdev/rumprun-toolchain-$tuple-$platform" --build-arg tuple="$tuple" --build-arg platform="$platform" .
