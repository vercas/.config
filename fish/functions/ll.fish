function ll -w ls
    if which lsd > /dev/null
        lsd -laF $argv --color always --icon always | less -RFX
    else
        ls -lAhF --color=auto $argv
    end
end
