function ll -w ls
    if type -q lsd
        lsd -laF $argv --color always --icon always | LESSUTFCHARDEF='E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p' less -RFX
    else
        ls -lAhF --color=auto $argv
    end
end
