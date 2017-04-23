#!/usr/bin/env bash

source $HOME/.config/shell-utilities.sh

if $TMX has-session 2> /dev/null; then
    echo "Session already exists!" 1>&2

    exit 1
fi

source $CDIR/tmux-create-session.sh

