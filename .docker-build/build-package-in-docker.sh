#!/bin/bash
exec docker run --rm=true \
                -v "$(cd "$(dirname "$0")/.."; echo "$PWD"):/rumprun-packages" \
                "${@:-davedoesdev/rumprun-pkgbuild-x86_64-rumprun-netbsd-hw}" \
                "$PACKAGE"
