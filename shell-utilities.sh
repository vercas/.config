#!/bin/sh

#   Note: This is exactly POSIX-compliant, but should be portable enough.

function backUp {
    local src=${1%/}
    # Yup, trailing slash is stripped away.

    if [ ! -e $src ]; then
        echo "backUp: '$src' is not a valid file or directory" >&2
        return 20
    fi

    local new=$src.old

    while [ -e $new ]; do
        new=$new.old
    done

    cp -Rn $src $new
    # Do a recursive copy if it's a directory, and also don't overwrite anything, in case something else created the file/folder after the loop above but before the copy command.
}

