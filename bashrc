export PS1="\[\e[32m\]\w\[\e[m\]: "
bind TAB:menu-complete

export TERM=xterm-256color

export PATH="$HOME/neovim/bin:~/bin:$PATH"
alias vim=nvim
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source /usr/local/rvm/scripts/rvm
