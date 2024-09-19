#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE}")"

echo "Updating dotfiles repository..."
git pull origin main

function copyDotfiles() {
  rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "bootstrap.sh" \
    --exclude "macos.sh" \
    --exclude "README.md" \
    --exclude "LICENSE-MIT.txt" \
    $1 \
    -ah --no-perms --itemize-changes . ~
}

function doIt() {
  copyDotfiles
  echo
  echo "Done. Restart your shell to apply the changes."
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  echo
  echo "The following changes will be made to your home directory ($HOME):"
  echo
  copyDotfiles "-n"
  echo
  read -p "Do you wish to continue? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
  fi;
fi;
unset doIt copyDotfiles
