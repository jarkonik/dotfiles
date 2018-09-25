FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y tmux neovim python3-pip  curl git
RUN pip3 install neovim

WORKDIR /root

RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
RUN nvim +'PlugUpdate --sync' +'PlugClean' +'UpdateRemotePlugins' +qall
RUN git clone https://github.com/nojhan/liquidprompt.git ~/liquidprompt

COPY init.vim .config/nvim/
COPY bashrc .bashrc
COPY inputrc .inputrc
COPY tmux.conf .tmux.conf