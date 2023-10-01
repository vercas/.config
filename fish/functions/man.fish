function man -w man
    set -lx LESS_TERMCAP_mb \e"[6m"
    set -lx LESS_TERMCAP_md \e"[01;31m"
    set -lx LESS_TERMCAP_me \e"[0m"
    set -lx LESS_TERMCAP_us \e"[01;32m"
    set -lx LESS_TERMCAP_ue \e"[0m"
    set -lx LESS_TERMCAP_so \e"[45;93m"
    set -lx LESS_TERMCAP_se \e"[0m"

    command man $argv
end

