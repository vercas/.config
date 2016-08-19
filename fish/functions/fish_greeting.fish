function fish_greeting
    if type -qf fortune
        if type -qf cowsay
            fortune -as | cowsay
        else
            fortune -as
        end
    else
        # This really is no fun. :L
        # I dunno what to do instead.
    end

    #set -l packageNotifier "/usr/lib/update-notifier/apt-check"

    #if test -x $packageNotifier
    #eval $packageNotifier --human-readable
    #end
end

