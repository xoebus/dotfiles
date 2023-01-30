#!/bin/sh

if [ ! -L ~/.config/git ]; then
  ln -s $PWD/git ~/.config/git
fi

if [ ! -L ~/.config/nvim ]; then
  ln -s $PWD/nvim ~/.config/nvim
fi
