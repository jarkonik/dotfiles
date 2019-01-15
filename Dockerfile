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

COPY * /root/dotfiles/
RUN /root/dotfiles/install.sh

WORKDIR /root

ENTRYPOINT [ "tmux", "-u", "-2" ]
