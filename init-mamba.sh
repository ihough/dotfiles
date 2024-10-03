# Source this script to activate micromamba:
#   source ~/init-mamba.sh
# Or, run in current shell
#   . ~/init-mamba.sh

echo "Activating micromamba"

# Parse and eval the output of `micromamba shell init --dry-run`
__mamba_shell_init="$(
  micromamba shell init --dry-run \
    | sed -n '/# >>> mamba initialize >>>$/,/^# <<< mamba initialize <<<$/p'
)"
eval "$__mamba_shell_init"
unset __mamba_shell_init

# Activate environment if specified
if ! [ -z "$1" ]; then
  echo "Loading environment $1"
  micromamba activate "$1"
fi
