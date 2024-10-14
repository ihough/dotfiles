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
export PATH="~/.local/bin:$PATH"

# Set mamba `$PATH`
# Do this after prepending ~/.local/bin to `$PATH` to prefer mamba-managed packages
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE="$(brew --prefix)/bin/micromamba"
export MAMBA_ROOT_PREFIX="$HOME/micromamba"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
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
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_main &> /dev/null; then
  __git_complete g __git_main
fi

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Dock Finder iTunes SystemUIServer Terminal" killall

#
# Misc options
#

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done
