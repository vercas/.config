function wat -d "Runs 'll', 'bat', or 'less', depending on which is the right one or which is available."
    if test (count $argv) = 0
        ll
    else
        if test -d $argv[1]
            ll $argv
        else if test -f $argv[1]
            if which bat > /dev/null
                bat $argv
            else
                less $argv
            end
        else
            echo "wat: '$argv[1]' is not a file nor a directory" >&2
            return 50
        end
    end
end

