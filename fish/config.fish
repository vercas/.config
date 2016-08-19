set -g theme_display_vi yes
set -g theme_display_git yes
set -g theme_show_exit_status yes
set -g theme_title_display_process yes
set -g theme_display_ruby no

switch (echo -n (hostname) | shasum | head -c 40)
case 21d705be9a22b5b5ac7d64c1de6aa820d168a457
	set -g theme_color_scheme base16-light
end

