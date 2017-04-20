HNS=$(echo -n `hostname` | sha1sum | head -c 40)

case $HNS in
7e7f4d3b88269bca7efea6939d35ae537028f864)
    TMX="tmux -S /home/guest/.tmux.socket"
    ;;
*)
    TMX="tmux"
    ;;
esac

