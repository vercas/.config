#!/usr/bin/env bash

# Some goodies.
source $HOME/.config/shell-utilities.sh

if [[ -n $HAS_HBDIR ]]; then
    # So the home bin directory was already in the path.

    for f in "${PATHSCRIPTS[@]}"; do
        ln -s "${CDIR}/$f" "${HBDIR}/$f"
    done
else
    # Then it must be global.

    for f in "${PATHSCRIPTS[@]}"; do
        sudo ln -s "${CDIR}/$f" "/usr/local/bin/$f"
    done
fi

backUp $HOME/.tmux.conf
ln -s $CDIR/.tmux.conf $HOME/.tmux.conf

