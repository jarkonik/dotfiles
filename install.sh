#!/bin/sh

# TODO: Set vim as system and git etc. editor
# TODO: Change prezto loop so it works in sh

settings=false
install=false

while getopts 'is' flag; do
    case "${flag}" in i) install=true ;;
	  s) settings=true ;;
    esac
done

if [ "$install" = true ]; then
  sudo apt-get update
  sudo apt-get -y install tmux neovim python3-pip &&
  pip3 install neovim --upgrade
else
  echo "Skipping install"
fi &&

if [ "$settings" = true ]; then
  nvim +'PlugUpdate --sync' +'PlugClean' +'UpdateRemotePlugins' +qall &&
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&

  rm -rf ~/liquidprompt
  git clone https://github.com/nojhan/liquidprompt.git ~/liquidprompt

  rm -rf ~/.bashrc &&
  rm -rf ~/.profile &&
  rm -rf ~/.inputrc &&
  rm -rf ~/.tmux.conf &&
  mkdir -p ~/.config/nvim &&
  rm -rf ~/.config/nvim/init.vim &&

  ln -s "$(pwd)/tmux.conf" ~/.tmux.conf &&
  ln -s "$(pwd)/bashrc" ~/.bashrc &&
  ln -s "$(pwd)/bashrc" ~/.profile &&
  ln -s "$(pwd)/init.vim" ~/.config/nvim/init.vim
  ln -s "$(pwd)/inputrc" ~/.inputrc
else
  echo "Skipping settings"
fi &&

echo "DONE!"
