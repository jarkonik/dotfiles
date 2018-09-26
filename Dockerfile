FROM alpine:latest

ENV TERM=xterm-color

RUN apk add tmux neovim curl git bash busybox-extras

WORKDIR /root

RUN apk add yasm clang python3 gdb

COPY init.vim .config/nvim/
RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
RUN nvim '+PlugInstall --sync' +qall

RUN apk add binutils

COPY bashrc .bashrc
COPY inputrc .inputrc
COPY tmux.conf .tmux.conf

ENTRYPOINT [ "tmux", "-u" ]