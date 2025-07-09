# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#
# Dotfiles
#

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend PATH.
# * ~/.extra can be used for other settings you don't want to commit.
for file in ~/.{path,prompt,exports,aliases,functions,extra}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

#
# Init micromamba
#

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba init' !!
export MAMBA_EXE='/home/houghi/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/workdir2/chianti/houghi/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

#
# Tab completions
#

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Force git completions to load - not sure why this is needed
. /usr/share/bash-completion/completions/git

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_main &> /dev/null; then
  __git_complete g __git_main
fi

# Enable tab completion for `micromamba` and `mm`
if command -v micromamba &> /dev/null; then
  _umamba_bash_completions()
  {
    COMPREPLY=($(micromamba completer "${COMP_WORDS[@]:1}"))
  }
  complete -o default -F _umamba_bash_completions micromamba
  complete -o default -F _umamba_bash_completions mm
fi

#
# Misc options
#

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done
