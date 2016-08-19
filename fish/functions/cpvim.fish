function cpvim -d "Copies a source file to the destination and opens the new one in Vim." -a src dst
	if test -f $src
		#	Source file exists, yay.
		#	Now there are three possibilities...

		if test -d $dst
			#	Destination is a directory... Means the file will be copied into it with the
			#	same name.

			set dst $dst/(basename $src)
		end

		if test -e $dst
			#	Destination exists. Will not proceed.

			echo "cpvim: destination file '$dst' already exists" >&2
			return 50
		end

		#	So destination refers to a non-existing file.

		cp -n $src $dst
		set -l cpStatus $status
		# Attempt copy and save exit status.

		test $cpStatus != 0; and return $cpStatus
		# If the copy failed for some reason, will not proceed.

		vim $dst
		# Finally, start Vim.
	else
		echo "cpvim: cannot copy '$src', no such file" >&2
		return 51
	end
end

