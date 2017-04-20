#!/usr/bin/env bash

#TMX="tmux -S /home/guest/.tmux.socket"
TMX="tmux-extended.sh"

if $TMX has-session 2> /dev/null; then
	#$TMX attach
	$TMX 0
else
	echo "There is no tmux session to connect to." 1>&2
	exit 1
fi

