parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\[\e[32m\]\w\[\e[m\]\[\e[35m\]\$(parse_git_branch)\[\e[m\]: "
bind TAB:menu-complete
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

export VISUAL=vim
export EDITOR="$VISUAL"
export TERM=xterm-256color

[[ -s "/usr/local/rvm/scripts/rvm" ]] && source /usr/local/rvm/scripts/rvm
