#!/bin/bash
exec docker run --rm=true \
                -v "$(dirname "$0")/..:/rumprun-packages" \
                "${@:-davedoesdev/rumprun-toolchain-x86_64-rumprun-netbsd-hw}" \
                "$PACKAGE"
