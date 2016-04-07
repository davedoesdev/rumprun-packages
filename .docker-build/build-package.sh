#!/bin/bash
set -e
if [ -z "$1" ]; then
  echo "No package specified"
  exit 1
fi
# install package dependencies
apt-get update -y && apt-get install -y curl autoconf genisoimage cmake python makefs bison ruby2.0
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 4
nvm use 4
# trusty messed up ruby2.0 (ubuntu:latest is currently trusty):
# https://bugs.launchpad.net/ubuntu/+source/ruby2.0/+bug/1310292
ln -sf ruby2.0 /usr/bin/ruby
cd "$(dirname "$0")/.."
echo "RUMPRUN_TOOLCHAIN_TUPLE=$RUMPRUN_TOOLCHAIN_TUPLE" > config.mk
cd "$1"
make
