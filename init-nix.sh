# Source this script to activate nix:
#   source ~/init-nix.sh
# Or, run in current shell
#   . ~/init-nix.sh

echo "Activating nix"

source /applis/site/nix.sh
if ! [ -z "$1" ]; then
  echo "Loading profile $1"
  nix-env --switch-profile $NIX_USER_PROFILE_DIR/$1;
fi
