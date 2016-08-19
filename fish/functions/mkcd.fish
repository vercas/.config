function mkcd -d "Creates a directory and changes to it."
	if test (count $argv) = 1
		if test ! -e $argv[1]
			mkdir $argv[1]; and cd $argv[1]
		else
			echo "mkcd: Cannot create directory '$argv[1]': File exists" >&2
		end
	else
		echo "mkcd: missing directory name"
	end
end

