#!/usr/bin/env bash

if [ -z ${TMUX+x} ]; then
    echo "You are not inside a TMUX session." 1>&2
    exit 1
else
    tmux -S `echo $TMUX | grep -oE "^([^,]+)"` ls
fi

