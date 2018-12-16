function ll -w ls
    if which lsd > /dev/null
        lsd -laF $argv
    else
        ls -lAhF --color=auto $argv
    end
end
