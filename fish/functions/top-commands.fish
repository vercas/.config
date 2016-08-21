function top-commands
    history | awk '{a[$1]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
end

