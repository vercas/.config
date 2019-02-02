function fish_greeting
    set -l cows cowsay

    if not type -qf $cows
        set cows '/usr/games/cowsay'
    end

    if type -qf $cows
        set -l twid (math (tput cols) - 3)

        if test $status -ne 0
            # Failed to get columns, meh...
            set cows '|' $cows -s
        else
            set cows '|' $cows -W $twid -s
        end
    else
        set cows ''
    end

    set -l fort fortune

    if not type -qf $fort
        set fort '/usr/games/fortune'
    end

    set -l aptc '/usr/lib/update-notifier/apt-check'

    if type -qf $fort
        eval $fort -as $cows
    else if test -x $aptc
        eval $aptc --human-readable $cows
    end

    if type -qf tb then
        tb --list pending
    end
end

