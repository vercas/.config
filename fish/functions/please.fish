function please -d "Retry the previous command with 'sudo'."
    if test $status -ne 0
        set -l cmd $history[1]

        if test -z $argv[1]
            set -l index 1

            while test $cmd = (status current-function)
                set index (math $index + 1)
                set cmd $history[$index]
            end
        else
            set cmd $history[$argv[1]]
        end

        eval sudo $cmd
    else
        echo "Previous function did not fail." 1>&2
        return 1
    end
end

