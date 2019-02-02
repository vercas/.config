function peek -w $EDITOR
    tmux split-window -p 33 $EDITOR $argv
end

