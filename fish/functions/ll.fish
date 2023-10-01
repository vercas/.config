function ll -w ls
    if type -q lsd
        lsd -laF --color always --icon always --git --date '+%y-%m-%d %H-%M-%S' $argv | less -RFX
    else
        ls -lAhF --color=auto $argv
    end
end
