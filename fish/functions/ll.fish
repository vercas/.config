function ll -w ls
    if type -q lsd
        lsd -laF $argv --color always --icon always | less -RFX
    else
        ls -lAhF --color=auto $argv
    end
end
