export PS1="\[\e[32m\]\w\[\e[m\]: "
bind TAB:menu-complete
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

export PATH="$HOME/neovim/bin:~/bin:$PATH"
alias vim=nvim
[[ -s "/usr/local/rvm/scripts/rvm" ]] && source /usr/local/rvm/scripts/rvm
