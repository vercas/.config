function wat -d "Runs 'll' or 'less', depending on which is the right one."
    if test (count $argv) = 0
        ll
    else
        if test -d $argv[1]
            ll $argv
        else if test -f $argv[1]
            less $argv
        else
            echo "wat: '$argv[1]' is not a file nor a directory" >&2
            return 50
        end
    end
end

