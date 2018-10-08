#!/bin/bash

docker build $(dirname "$0") -t dotfiles &&
winpty docker run -v /$(PWD):/mnt --rm -it dotfiles
