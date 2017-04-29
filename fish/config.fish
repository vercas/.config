# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
set -g theme_display_vi yes
set -g theme_display_git yes
set -g theme_show_exit_status yes
set -g theme_title_display_process yes
set -g theme_display_ruby no

switch (echo -n (hostname) | sha1sum | head -c 40)
case 21d705be9a22b5b5ac7d64c1de6aa820d168a457
    switch (echo -n (uname) | sha1sum | head -c 40)
    case c12b02b9ecce6a5392bd7aaf12a084a573ea38d7
        set -g theme_color_scheme dark
        set -gx PATH /usr/local/bin /usr/bin /bin $PATH
        set -gx DISPLAY 127.0.0.1:0.0

        eval (dircolors.exe -b | sed "s/LS_COLORS=/set -x LS_COLORS /")
    case '*'
        set -g theme_color_scheme base16-light
    end
case 27d30547559b399e16c744df4c2bcbd41974851b
    set -g theme_color_scheme terminal-dark
case 7e7f4d3b88269bca7efea6939d35ae537028f864
    set -gx GOPATH "$HOME/go"
end

set -x EDITOR vim

if not contains ~/bin $PATH
    set -gx PATH ~/bin $PATH
end

if test -S '/tmp/vercas.ssh.agent.socket'
    set -gx SSH_AUTH_SOCK '/tmp/vercas.ssh.agent.socket'
end

