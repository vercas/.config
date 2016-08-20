#!/bin/sh

# First, some goodies.
source shell-utilities.sh

# Create necessary directories.
mkdir -p ~/.vim/{bundle,backup,undo,swap} 

# Clone Vundle.
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Back up old .vimrc if it exists.
backUp ~/.vimrc

# Remove existing .vimrc, if any. Like, if the backup failed. Soz.
rm -f ~/.vimrc

# Finally, symlink .vimrc
ln -s $HOME/.config/.vimrc ~/.vimrc

# And the cherry on top of the cake, installing the plugins.
vim +PluginInstall +qall

