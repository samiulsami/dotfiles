if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_default_key_bindings

alias kc="kubectl"
alias i3l="i3lock -uc 000000"

alias tnt='tmux new -t'

alias fzfp='fzf -m --preview "batcat --color=always --style=numbers --line-range=:500 {}"'
set fzf_fd_opts --hidden --max-depth 5 --color=always
set fzf_preview_file_cmd bat --color=always --style=numbers --line-range=:500

zoxide init fish | source
alias zp='z $(zoxide query -l | fzf)'

nvm use 22 > /dev/null
