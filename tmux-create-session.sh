SES=$($TMX new-session -d -P)

if [[ -r $HOME/.tmux.windows ]]; then
    function WIN() {
        $TMX new-window -P $@
    }

    function OPT() {
        $TMX set-window-option -t "${SES}$1" ${@:2}
    }

    source $HOME/.tmux.windows
fi

