#!/usr/bin/env bash

$@

# Simple... Now, when it quits...

echo ""
echo "---"
read -n 1 -p "Press any key to respawn the window..."

tmux respawn-window -k

