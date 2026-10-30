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

function linkToPath {
    local src="${CDIR}/${1}"

    if [[ ! -f $src ]]; then
        echo "linkToPath: '${src}' does not exist." 1>&2
        return 1
    fi

    #   Only a home bin directory that is already on the path is of any use; installing into
    #   one nobody looks at would hide the command away rather than provide it. The system's
    #   own bin directory takes it in that case, which needs root to write to.
    if [[ -z $HAS_HBDIR ]]; then
        sudo ln -sfn "$src" "/usr/local/bin/${1}" && echo "Linked '${1}' into '/usr/local/bin'."
        return $?
    fi

    mkdir -p "${HBDIR}" 2> /dev/null || { echo "linkToPath: cannot create '${HBDIR}'." 1>&2; return 1; }

    ln -sfn "$src" "${HBDIR}/${1}" && echo "Linked '${1}' into '${HBDIR}'."
}

function linkIntoHome {
    local src="${CDIR}/${1}" dst="${HOME}/${1}"

    if [[ ! -f $src ]]; then
        echo "linkIntoHome: '${src}' does not exist." 1>&2
        return 1
    fi

    #   A correct link is left exactly as it is, or running this again would rotate another
    #   '.old' copy of the same symlink into place every single time.
    if [[ -L $dst && $(readlink "${dst}") == "$src" ]]; then
        echo "'${dst}' is already linked."
        return 0
    fi

    backUp "${dst}"
    ln -sfn "$src" "${dst}" && printf "Linked '%s' into your home directory.\n" "$1"
}

HNS=$(echo -n "$HOSTNAME" | sha1sum | head -c 40)

case "$HNS" in
7e7f4d3b88269bca7efea6939d35ae537028f864)
    TMX="tmux -S /home/guest/.tmux.socket"
;;
*)
    TMX="tmux"
;;
esac

CDIR="${HOME}/.config"
HBDIR="${HOME}/.local/bin"

PATHSCRIPTS=(vmux tmux-list-my-sessions.sh list-batteries.sh tmux-respawnable.sh)

if [[ ":${PATH}:" == *":${HBDIR}:"* ]]; then
    HAS_HBDIR=1
else
    PATH="${HBDIR}:${PATH}"
fi

