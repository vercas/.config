function wat -d "Runs 'll' or 'less', depending on which is the right one."
    if test (count $argv) = 0
        ll
    else
        less $argv 2> /dev/null; or ll $argv
    end
end

