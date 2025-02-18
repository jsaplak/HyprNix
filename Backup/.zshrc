alias hypr='nvim .config/hypr/hyprland.conf'

alias nconf='nvim /etc/nixos/configuration.nix'

autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "


bindkey '^[[1;5D' backward-word

bindkey '^[[1;5C' forward-word

bindkey '^H' backward-kill-word
