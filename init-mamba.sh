# Source this script to activate micromamba:
#   source ~/init-mamba.sh
# Or, run in current shell
#   . ~/init-mamba.sh

echo "Activating micromamba"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/houghi/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/houghi/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Enable tab completion for `mm` by marking it as an alias for `micromamba`
if type _umamba_bash_completions &> /dev/null; then
  complete -o default -F _umamba_bash_completions mm
fi

# Activate environment if specified
if ! [ -z "$1" ]; then
  echo "Loading environment $1"
  micromamba activate "$1"
fi
