#!/bin/sh

# TODO: Set vim as system and git etc. editor

settings=false
install=false

while getopts 'is' flag; do
    case "${flag}" in i) install=true ;;
	  s) settings=true ;;
    esac
done

if [ "$install" = true ]; then
  sudo apt-get update &&
  sudo apt-get -y install tmux vim
else
  echo "Skipping install"
fi &&

if [ "$settings" = true ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&
  vim '+PlugInstall --sync' +qall &&
  rm -rf ~/.bashrc &&
  rm -rf ~/.inputrc &&
  rm -rf ~/.tmux.conf &&
  rm -rf ~/.vimrc &&
  ln -s "$(pwd)/tmux.conf" ~/.tmux.conf &&
  ln -s "$(pwd)/bashrc" ~/.bashrc &&
  ln -s "$(pwd)/vimrc" ~/.vimrc &&
  ln -s "$(pwd)/inputrc" ~/.inputrc
else
  echo "Skipping settings"
fi &&

echo "DONE!"
