#!/usr/bin/env bash

# Utilitary variables
VIMDIR=$HOME/.vim

# Some goodies.
source $HOME/.config/shell-utilities.sh

# Create necessary directories.
mkdir -p $VIMDIR/{bundle,backup,undo,swap}

# Clone Vundle.
git clone https://github.com/VundleVim/Vundle.vim.git $VIMDIR/bundle/Vundle.vim

backUp $HOME/.vimrc
ln -s $HOME/.config/.vimrc $HOME/.vim/vimrc

# And the cherry on top of the cake, installing the plugins.
vim +PluginInstall +qall

