#!/bin/env bash

# Utilitary variables
VIMDIR=$HOME/.vim

# Some goodies.
source shell-utilities.sh

# Create necessary directories.
mkdir -p $VIMDIR/bundle
mkdir -p $VIMDIR/backup
mkdir -p $VIMDIR/undo
mkdir -p $VIMDIR/swap

# Clone Vundle.
git clone https://github.com/VundleVim/Vundle.vim.git $VIMDIR/bundle/Vundle.vim

# Back up old .vimrc if it exists.
backUp ~/.vimrc || return 30

# Remove existing .vimrc, if any. Like, if the backup failed. Soz.
rm -f ~/.vimrc

# Finally, symlink .vimrc
ln -s $HOME/.config/.vimrc ~/.vimrc

# And the cherry on top of the cake, installing the plugins.
vim +PluginInstall +qall

