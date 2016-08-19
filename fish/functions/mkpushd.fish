function mkpushd -d "Creates a directory and pushes it into the stack."
	if test (count $argv) = 1
		if test ! -e $argv[1]
			mkdir $argv[1]; and pushd $argv[1]
		else
			echo "mkpushd: Cannot create directory '$argv[1]': File exists" >&2
		end
	else
		echo "mkpushd: missing directory name"
	end
end

