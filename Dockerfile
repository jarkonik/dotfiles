FROM alpine:latest

RUN apk add \
    tmux \
    vim \
    curl \
    git \
    bash \
    busybox-extras \
    yasm \
    python3 \
    gdb \
    gcc \
    g++ \
    binutils

WORKDIR /root

COPY bashrc .bashrc
COPY inputrc .inputrc
COPY tmux.conf .tmux.conf
COPY vimrc .vimrc

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN vim '+PlugInstall --sync' +qall

RUN git config --global user.email "konikjar@gmail.com"
RUN git config --global user.name "Jaroslaw Konik"

ENTRYPOINT [ "tmux", "-u", "-2" ]