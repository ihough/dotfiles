# Set locale and default group for interactive SSH shells
if [[ $- == *i* && -n "$SSH_CONNECTION" ]]; then
  if [ -f "$HOME/.i18n" ]; then
    . "$HOME/.i18n"
  fi

  # Do NOT use in .bashrc b/c newgrp creates a new shell -> loop
  if [[ $(id -gn) != "pr-geoschem" ]]; then
    exec newgrp pr-geoschem
  fi
fi

# Include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
