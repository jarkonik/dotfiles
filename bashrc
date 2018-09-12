[[ $- = *i* ]] && source ~/liquidprompt/liquidprompt
export TERM=xterm-256color
export PATH="$HOME/neovim/bin:~/bin:$PATH"
alias vim=nvim

# FOR WORK
alias lion="ssh jaroslaw.konik@lion"
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source /usr/local/rvm/scripts/rvm
export PATH=$PATH:~/Projects/depot_tools
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
# END FOR WORK
