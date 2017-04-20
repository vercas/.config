#!/usr/bin/env bash

source ~/.config/bash-config.sh

if $TMX has-session 2> /dev/null; then
    echo "Session already exists!" 1>&2

    exit 1
fi

$TMX new-session -d
$TMX new-window

