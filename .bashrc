nvr_git () {
	local main_module_repo_path=$(git rev-parse --show-superproject-working-tree 2>/dev/null)
	local repo_path=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -z "$main_module_repo_path" ]]; then
		main_module_repo_path=$repo_path
	fi

	if [ -n "$main_module_repo_path" ]; then
		local servername=/tmp/nvr$(echo $main_module_repo_path | tr "/" "_")
		nvr -s --servername $servername "$@"
	else
		/usr/bin/nvim "$@"
	fi
}

alias nvim=nvr_git
export EDITOR=nvim
export PATH="$PATH:$HOME/.cargo/bin"
. "$HOME/.cargo/env"
eval "$(starship init bash)"
alias export_esp=". /home/jaroslaw/bin/export-esp.sh"
alias get_idf='. $HOME/src/esp/esp-idf/export.sh'
