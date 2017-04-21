#!/usr/bin/env bash

# Some goodies.
source $HOME/.config/shell-utilities.sh

lua -v > /dev/null || exit 1

LPP=$(lua -e "print(package.path)")
LPP_REGEX='([^;]*\/usr(\/local)?\/share\/lua\/5\.[0-9]+)\/\?.lua\b'

if [[ $LPP =~ $LPP_REGEX ]]; then
    LDIR="${BASH_REMATCH[1]}"
else
    echo "Failed to find a useable Lua include directory in:" $LPP 1>&2
    echo "Regex:" "${LPP_REGEX}"
    exit 2
fi

sudo ln -s $CDIR/vline.lua $LDIR/vline.lua

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

