#!/usr/bin/env bash

source $HOME/.config/shell-utilities.sh

if ! $TMX has-session 2> /dev/null; then
    source $CDIR/tmux-create-session.sh
fi

$CDIR/tmux-extended.sh 0

