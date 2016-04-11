#!/bin/bash
# usage: commit.sh <repo-name>...
export DTUF_REPOSITORIES_ROOT="$(dirname "$0")/dtuf_repos"
echo "$DTUF_REPOSITORIES_ROOT"
for repo in "$@"
do
  echo dtuf push-metadata "teksilo/$repo"
done
