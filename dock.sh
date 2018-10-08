#!/bin/bash

docker build $(dirname "$0") -t dotfiles &&
winpty docker run -v /$(PWD):/mnt --rm --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it dotfiles
