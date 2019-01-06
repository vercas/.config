function .prependsudo
    set -l prepend 'sudo'

    set -l cmd (commandline)
    if test -z "$cmd"
        commandline -r $history[1]
    end

    set -l old_cursor (commandline -C)
    commandline -C 0
    commandline -i "$prepend "
    commandline -C (math $old_cursor + (echo $prepend | wc -c))
end

