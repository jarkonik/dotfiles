FROM alpine:latest

RUN apk add \
    tmux \
    neovim \
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
COPY init.vim .config/nvim/
RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim '+PlugInstall --sync' +qall
COPY bashrc .bashrc
COPY inputrc .inputrc
COPY tmux.conf .tmux.conf

ENTRYPOINT [ "tmux", "-u", "-2" ]
