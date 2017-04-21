#!/usr/bin/env bash

#   Note: This is not exactly POSIX-compliant, but should be portable enough.

function backUp {
    local src="${1%/}"
    # Yup, trailing slash is stripped away.

    if [[ ! -e $src ]]; then
        #echo "backUp: '$src' is not a valid file or directory" >&2
        #return 20
        return 0
        # Not an issue.
    fi

    local new="$src.old"

    backUp "$new.old"

    mv -n "$src" "$new" 2> /dev/null || :
    # Move the file/directory, and also don't overwrite anything, in case something else created the file/directory after the loop above but before the copy command.
}

HNS=$(echo -n `hostname` | sha1sum | head -c 40)

case "$HNS" in
7e7f4d3b88269bca7efea6939d35ae537028f864)
    TMX="tmux -S /home/guest/.tmux.socket"
;;
*)
    TMX="tmux"
;;
esac

CDIR="${HOME}/.config"
HBDIR="${HOME}/bin"

PATHSCRIPTS=(start-tmux.sh attach-to-tmux.sh tmux-extended.sh tmux-list-my-sessions.sh list-batteries.sh start-or-attach-to-tmux.sh)

if [[ ":${PATH}:" == *":${HBDIR}:"* ]]; then
    HAS_HBDIR=1
else
    PATH="${HBDIR}:${PATH}"
fi

