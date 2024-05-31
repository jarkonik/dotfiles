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
export EDITOR=nvim
export PATH="$PATH:$HOME/.cargo/bin"
. "$HOME/.cargo/env"
eval "$(starship init zsh)"
alias export_esp=". /home/jaroslaw/bin/export-esp.sh"
alias get_idf='. $HOME/src/esp/esp-idf/export.sh'
