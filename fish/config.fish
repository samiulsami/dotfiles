if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_default_key_bindings

alias gg="git gui"
alias gs="git status"
alias gm="git fetch origin --prune --tags -f;git checkout master;git pull origin master"
alias gmn="git fetch origin --prune --tags -f;git checkout main;git pull origin main"
alias gp="git add .;git commit -a -s -m wip;git push origin HEAD"
alias g2h="git push origin HEAD"
alias gr="git reset --hard HEAD"
alias gmv="go mod tidy; go mod vendor"
alias ga="git add .;git commit --amend --no-edit -a -s"
alias gcp="git cherry-pick"
alias gch="git checkout"
alias gl="git log --oneline -5"

alias kc="kubectl"
alias i3l="i3lock -uc 000000"

alias tnt='tmux new -t'

alias fzfp='fzf -m --preview "batcat --color=always --style=numbers --line-range=:500 {}"'
set fzf_fd_opts --hidden --max-depth 5 --color=always
set fzf_preview_file_cmd bat --color=always --style=numbers --line-range=:500

nvm use 22 > /dev/null

zoxide init fish | source

