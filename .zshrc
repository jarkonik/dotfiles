# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jaroslaw/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# unset SSH_ASKPASS
# export PYTHONSTARTUP=.python_startup.py
# eval "$(~/.rbenv/bin/rbenv init - bash)"
# alias nvim=nvim_listen.sh
# export TERM='xterm-256color'
#

nvr_git () {
	local repo_path=$(git rev-parse --show-superproject-working-tree 2>/dev/null)
	if [ -n "$repo_path" ]; then
		local servername=/tmp/nvr$(echo $repo_path | tr "/" "_")
		nvr -s --servername $servername "$@"
	else
		/usr/bin/nvim "$@"
	fi
}

alias nvim=nvr_git
alias vim=nvim
export EDITOR=nvim
export PATH="$PATH:$HOME/.cargo/bin"
. "$HOME/.cargo/env"
eval "$(starship init zsh)"
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Wasmer
# export WASMER_DIR="/home/jaroslaw/.wasmer"
# [ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
alias export_esp=". /home/jaroslaw/bin/export-esp.sh"
alias get_idf='. $HOME/src/esp/esp-idf/export.sh'

[ -f "/home/jaroslaw/.ghcup/env" ] && . "/home/jaroslaw/.ghcup/env" # ghcup-env

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

ssh-add -q ~/.ssh/id_rsa
eval `luarocks path`
