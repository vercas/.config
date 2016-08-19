set -g theme_display_vi yes
set -g theme_display_git yes
set -g theme_show_exit_status yes
set -g theme_title_display_process yes
set -g theme_display_ruby no

switch (hostname)
case VULT
	set -g theme_color_scheme base16-light
end

