switch (echo -n $hostname | sha1sum | head -c 40)
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
set -gx LESS '-R --mouse --wheel-lines=3'

if test -x '/usr/share/source-highlight/src-hilite-lesspipe.sh'
    set -gx LESSOPEN '| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
end

if test -e "/home/linuxbrew/.linuxbrew/bin/brew" > /dev/null 2> /dev/null
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

function __vconfig_add_path
    if test -d $argv[1]; and not contains $argv[1] $PATH
        if test "$argv[2]" = "--append"
            set -gxa PATH $argv[1]
        else
            set -gxp PATH $argv[1]
        end
    end
end

__vconfig_add_path ~/.dotnet/tools --append
__vconfig_add_path /usr/lib/icecc/bin
__vconfig_add_path ~/.cargo/bin
__vconfig_add_path ~/.luarocks/bin
__vconfig_add_path ~/bin
__vconfig_add_path ~/.local/bin

if test -S "$HOME/.ssh/ssh_auth_sock"
    set -gx SSH_AUTH_SOCK "$HOME/.ssh/ssh_auth_sock"
end

#source "$HOME/.config/fish/iterm2_shell_integration.fish"

if set -q KITTY_INSTALLATION_DIR; and not set -q KITTY_SHELL_INTEGRATION
    set --global KITTY_SHELL_INTEGRATION enabled
    source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
    set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
end

if test -d "/home/linuxbrew/.linuxbrew/opt/dotnet/libexec"
    set -gx DOTNET_ROOT "/home/linuxbrew/.linuxbrew/opt/dotnet/libexec"
end

if which dotnet > /dev/null 2> /dev/null
    set -gx DOTNET_CLI_TELEMETRY_OPTOUT true
end

