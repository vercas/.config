#!/bin/bash

#
# Modified TMUX start script from:
#     http://forums.gentoo.org/viewtopic-t-836006-start-0.html
#
# Store it to `~/bin/tmx` and issue `chmod +x`.
#

source ~/.config/bash-config.sh

# Works because bash automatically trims by assigning to variables and by 
# passing arguments
trim() { echo $1; }

if [[ -z "$1" ]]; then
    echo "Specify session name as the first argument"
    exit
fi

# Only because I often issue `ls` to this script by accident
if [[ "$1" == "ls" ]]; then
    $TMX ls
    exit
fi

if [[ "$1" == "has-session" ]]; then
    $TMX has-session
    exit $?
fi

base_session="$1"
# This actually works without the trim() on all systems except OSX
tmux_nb=$(trim `$TMX ls | grep "^$base_session" | wc -l`)
if [[ "$tmux_nb" == "0" ]]; then
    #echo "Launching tmux base session $base_session ..."
    #$TMX new-session -s $base_session

    echo "Base session does not exist!" 1>&2
    exit 1
else
    # Make sure we are not already in a tmux session
    if [[ -z "$TMUX" ]]; then
        # Kill defunct sessions first
        old_sessions=$($TMX ls 2>/dev/null | egrep "^[A-Za-z0-9\+\/=]{7}[A-Za-z0-9\+\/=]*:.*\(group\s+$base_session\)$" | cut -f 1 -d:)
        for old_session_id in $old_sessions; do
            $TMX kill-session -t $old_session_id
        done

        echo "Launching copy of base session $base_session ..."
        # Session is is date and time to prevent conflict
        #session_id=`date +%Y%m%d%H%M%S`
        session_id=`printf "0: %.12x" $(date +%Y%m%d%H%M%S) | xxd -r -g0 | base64`
        # Create a new session (without attaching it) and link to base session 
        # to share windows
        $TMX new-session -d -t $base_session -s $session_id
        # Create a new window in that session
        #tmux new-window
        # Attach to the new session
        $TMX attach-session -t $session_id
        # When we detach from it, kill the session
        $TMX kill-session -t $session_id
    fi
fi 

