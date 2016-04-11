#!/bin/bash
# usage: push.sh <repo-name> <version> <file>
export DTUF_REPOSITORIES_ROOT="$(dirname "$0")/dtuf_repos"
echo "$DTUF_REPOSITORIES_ROOT"
echo dtuf push-target "teksilo/$1" "$2-$RUMPRUN_TOOLCHAIN_TUPLE-$RUMPRUN_PUBLISH_CONFIG" "$3"
