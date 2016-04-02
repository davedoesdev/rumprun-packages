#!/bin/bash
cd "$(dirname "$0")"
docker build -f Dockerfile.toolchain-base -t davedoesdev/rumprun-toolchain-base .
