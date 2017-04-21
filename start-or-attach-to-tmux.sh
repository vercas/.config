#!/usr/bin/env bash

source $HOME/.config/shell-utilities.sh

if ! $TMX has-session 2> /dev/null; then
    $TMX new-session -d
    $TMX new-window
fi

$CDIR/tmux-extended.sh 0

