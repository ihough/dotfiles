#
# Dotfiles
#

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,prompt,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

#
# Package mangers, `$PATH`, prompt
#

# Set homebrew `$PATH` and env vars
if [ -f /opt/homebrew/bin/brew ]; then  # Apple silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then  # Intel
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Prepend ~/.local/bin to `$PATH`
# Do this after homebrew init, which clobbers `$PATH`
export PATH=~/.local/bin:$PATH

# Set mamba `$PATH`
# Do this after prepending ~/.local/bin to `$PATH` to prefer mamba-managed packages
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="$(brew --prefix)/bin/micromamba"
export MAMBA_ROOT_PREFIX="$HOME/micromamba"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

#
# Tab completions
#

# Add Homebrew's tab completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Enable full zsh completions
autoload -Uz compinit
compinit
