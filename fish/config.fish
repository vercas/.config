switch (echo -n (hostname) | sha1sum | head -c 40)
case 27d30547559b399e16c744df4c2bcbd41974851b
    set -g theme_color_scheme terminal-dark
case 7e7f4d3b88269bca7efea6939d35ae537028f864
    set -gx GOPATH "$HOME/go"
case 515dd919689cf68643e573f27d47aef3897e66a3
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    set -gx LC_ALL 'en_GB.UTF-8'
case 8ae010365d154fa313ec8d99703227032fe8434f
    set -gx LC_ALL 'en_GB.UTF-8'
end

set -gx EDITOR vim
set -gx LESS ' -R '

if test -x '/usr/share/source-highlight/src-hilite-lesspipe.sh'
    set -gx LESSOPEN '| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
end

if test -d '/usr/lib/icecc/bin'; and not contains '/usr/lib/icecc/bin' $PATH
    set -gx PATH '/usr/lib/icecc/bin' $PATH
end
if test -d ~/bin; and not contains ~/bin $PATH
    set -gx PATH ~/bin $PATH
end
if test -d ~/.local/bin; and not contains ~/.local/bin $PATH
    set -gx PATH ~/.local/bin $PATH
end
if test -d ~/.cargo/bin; and not contains ~/.cargo/bin $PATH
    set -gx PATH ~/.cargo/bin $PATH
end

if test -S '~/.ssh/ssh_auth_sock'
    set -gx SSH_AUTH_SOCK '~/.ssh/ssh_auth_sock'
end

