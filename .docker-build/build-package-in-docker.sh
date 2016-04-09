#!/bin/bash
if [ -n "$SWAP_GB" ]; then
  fallocate -l "${SWAP_GB}G" /swapfile
  mkswap /swapfile
  swapon /swapfile
  free -m
fi
exec docker run --rm=true \
                -v "$(cd "$(dirname "$0")/.."; echo "$PWD"):/rumprun-packages" \
                "${@:-davedoesdev/rumprun-pkgbuild-x86_64-rumprun-netbsd-hw}" \
                "$PACKAGE"
