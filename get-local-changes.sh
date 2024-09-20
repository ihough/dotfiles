#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

function listTracked() {
  git ls-tree -r --name-only ciment \
    | grep -Ev '(bootstrap.sh|get-local-changes.sh|macos.sh|README.md|LICENSE-MIT.txt)'
}

for file in $(listTracked); do
  cp -fv ~/$file $file
done
