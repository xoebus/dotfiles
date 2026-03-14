#!/bin/sh

# Install dependencies
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$PWD/Brewfile"
else
  echo "Homebrew not found — skipping dependency install"
  echo "Install Homebrew from https://brew.sh, then re-run this script"
fi

# Install Go tools (not available via Homebrew)
if command -v go >/dev/null 2>&1; then
  go install golang.org/x/tools/gopls@latest
  go install golang.org/x/tools/cmd/goimports@latest
else
  echo "go not found — skipping Go tool install"
fi

# Symlink configs
if [ ! -L ~/.config/git ]; then
  ln -s $PWD/git ~/.config/git
fi

if [ ! -L ~/.config/nvim ]; then
  ln -s $PWD/nvim ~/.config/nvim
fi

if [ ! -L ~/.config/tmux ]; then
  ln -s $PWD/tmux ~/.config/tmux
fi

if [ ! -L ~/.config/ghostty ]; then
  ln -s $PWD/ghostty ~/.config/ghostty
fi
