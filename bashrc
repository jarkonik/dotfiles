if [[ $- == *i* ]]
then
  export PS1="\[\e[32m\]\W\[\e[m\] "
  bind TAB:menu-complete
  bind "set show-all-if-ambiguous on"
  bind "set menu-complete-display-prefix on"
  alias start='cmd.exe /c start'
fi

export VISUAL=vim
export EDITOR="$VISUAL"
export TERM=xterm-256color
export DISPLAY=localhost:0.0
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
