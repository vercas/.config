function ll -w ls
    if which lsd
        lsd -laF $argv
    else
        ls -lAhF --color=auto $argv
    end
end
