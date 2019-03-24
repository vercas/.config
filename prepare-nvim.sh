#!/usr/bin/env bash

# Create necessary directories.
mkdir -p $HOME/.local/share/nvim/{backup,undo,swap}
mkdir -p $HOME/.config/nvim/bundle

# Clone Vundle.
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.config/nvim/bundle/Vundle.vim

# And the cherry on top of the cake, installing the plugins.
nvim +PluginInstall +qall

