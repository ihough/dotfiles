#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

function listTracked() {
  git ls-tree -r --name-only spirit \
    | grep -Ev '(bootstrap.sh|get-local-changes.sh|macos.sh|README.md|LICENSE-MIT.txt)'
}

for file in $(listTracked); do
  if [ -f ~/"$file" ]; then
    cp -fv ~/"$file" "$file"
  else
    echo "~/$file does not exist"
    rm -iv "$file"
  fi
done
