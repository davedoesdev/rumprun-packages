#!/bin/bash
cd "$(dirname "$0")"
docker build -f Dockerfile.base -t davedoesdev/rumprun-base .
