#!/bin/bash

docker build $(dirname "$0") -t dotfiles &&
winpty docker run -v /$(PWD):/mnt -p 8000:8000 --rm --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it dotfiles
