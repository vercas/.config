function fish_greeting
    if type -qf fortune
        if type -qf cowsay
            set -l twid (math (tput cols) - 3)

            if test $status -ne 0
                # Failed to get columns, meh...
                fortune -as | cowsay -s
            else
                fortune -as | cowsay -W $twid -s
            end
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

