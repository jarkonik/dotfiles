#!/bin/sh

cd "$(dirname "$0")"

rm -rf ~/.bashrc &&
rm -rf ~/.inputrc &&
rm -rf ~/.tmux.conf &&
rm -rf ~/.vimrc &&

ln -s "$(pwd)/tmux.conf" ~/.tmux.conf &&
ln -s "$(pwd)/bashrc" ~/.bashrc &&
ln -s "$(pwd)/vimrc" ~/.vimrc &&
ln -s "$(pwd)/inputrc" ~/.inputrc &&

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&
vim '+PlugInstall --sync' +qall &&

git config --global user.email "konikjar@gmail.com" &&
git config --global user.name "Jaroslaw Konik"

echo "DONE!"
