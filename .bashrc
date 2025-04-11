alias nvim=nvr_git
export EDITOR=nvim
export PATH="$PATH:$HOME/.cargo/bin"
. "$HOME/.cargo/env"
eval "$(starship init bash)"
alias export_esp=". /home/jaroslaw/bin/export-esp.sh"
alias get_idf='. $HOME/src/esp/esp-idf/export.sh'
export WGPU_BACKEND=opengl
