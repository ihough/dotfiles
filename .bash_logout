# ~/.bash_logout: executed by bash(1) when login shell exits.

# Kill any running ssh-agent
if [ -n "$SSH_AGENT_PID" ] ; then
  eval `/usr/bin/ssh-agent -k`
fi

# When leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
  [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
