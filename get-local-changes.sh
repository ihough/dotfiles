#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

function listTracked() {
  git ls-tree -r --name-only main \
    | grep -Ev '(bootstrap.sh|get-local-changes.sh|macos.sh|README.md|LICENSE-MIT.txt)'
}

for file in $(listTracked); do
  if [ -f "$HOME/$file" ]; then
    cp -fv "$HOME/$file" "$file"
  else
    echo "$HOME/$file does not exist"
    rm -iv "$file"
  fi
done
