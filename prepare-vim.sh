#!/usr/bin/env bash

# Utilitary variables
VIMDIR=$HOME/.vim

# Some goodies.
source shell-utilities.sh

# Create necessary directories.
mkdir -p $VIMDIR/{bundle,backup,undo,swap}

# Clone Vundle.
git clone https://github.com/VundleVim/Vundle.vim.git $VIMDIR/bundle/Vundle.vim

# Back up old .vimrc if it exists.
if [ -e ~/.vimrc ]; then
    backUp ~/.vimrc

    local st=$?

    [ st -ne 0 ] && exit st
    # It's useful to report errors.
fi

# Remove existing .vimrc, if any. Like, if the backup failed. Soz.
rm -f ~/.vimrc

# Finally, symlink .vimrc
ln -s $HOME/.config/.vimrc ~/.vim/vimrc

# And the cherry on top of the cake, installing the plugins.
vim +PluginInstall +qall

