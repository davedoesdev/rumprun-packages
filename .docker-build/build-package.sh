#!/bin/sh
set -e
if [ -z "$1" ]; then
  echo "No package specified"
  exit 1
fi
# install package dependencies
apt-get update -y && apt-get install -y curl autoconf genisoimage cmake python makefs bison ruby2.0
# trusty messed up ruby2.0 (ubuntu:latest is currently trusty):
# https://bugs.launchpad.net/ubuntu/+source/ruby2.0/+bug/1310292
ln -sf ruby2.0 /usr/bin/ruby
cd "$(dirname "$0")/.."
echo "RUMPRUN_TOOLCHAIN_TUPLE=$RUMPRUN_TOOLCHAIN_TUPLE" > config.mk
cd "$1"
make -j2
