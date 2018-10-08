#!/bin/bash

docker build . -t dotfiles &&
winpty docker run -v /$(PWD):/mnt --rm -it dotfiles
