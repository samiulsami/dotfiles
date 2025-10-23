# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

WORDCHARS='*?[]~=\@.:; -_&;!#$%^(){}<>/|'

fpath=($HOME/.zsh/zsh-completions/src $fpath)
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit
compinit

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

setopt NO_CASE_GLOB
setopt NO_CASE_MATCH
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle ':completion:*' matcher-list '' \
        'm:{a-z\-}={A-Z\_}' \
        'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
        'r:|?=** m:{a-z\-}={A-Z\_}'

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'l' vi-forward-char
bindkey -a "k" .up-line-or-history
bindkey -a "j" .down-line-or-history

bindkey -M menuselect '\e' send-break
bindkey -M menuselect '^N' down-line-or-history
bindkey -M menuselect '^P' up-line-or-history

function vi-history-up-and-highlight() {
        zle vi-up-line-or-history
        zle zle-line-init
        zle end-of-line
}
zle -N vi-history-up-and-highlight

function vi-history-down-and-highlight() {
        zle vi-down-line-or-history
        zle zle-line-init
        zle end-of-line
}
zle -N vi-history-down-and-highlight

bindkey -M vicmd 'k' vi-history-up-and-highlight
bindkey -M vicmd 'j' vi-history-down-and-highlight

KEYTIMEOUT=0

setopt AUTO_CD
setopt AUTO_PUSHD
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt AUTO_PARAM_SLASH
setopt LIST_PACKED
setopt EXTENDEDGLOB
setopt NOTIFY
setopt NOMATCH
setopt INTERACTIVE_COMMENTS

HISTFILE=$HOME/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt APPEND_HISTORY            # Add new commands to the history file, instead of overwriting it.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

unsetopt BEEP

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source ~/.p10k.zsh

source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme

ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=100

source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
ZVM_CURSOR_STYLE_ENABLED=false
ZVM_ESCAPE_KEYTIMEOUT=0

function my_init() {
        source <(fzf --zsh)
        export FZF_DEFAULT_COMMAND='fd --hidden --color=always'
        export FZF_DEFAULT_OPTS="--ansi ${FZF_DEFAULT_OPTS} --multi --cycle --tiebreak=length,begin,end"
        export FZF_DEFAULT_OPTS="--bind='ctrl-y:accept,ctrl-a:select-all,ctrl-d:deselect-all' ${FZF_DEFAULT_OPTS}"
        export FZF_PREVIEW_FILE_CMD='bat --color=always --style=numbers --line-range=:500'

        bindkey -a '\er' fzf-history-widget
        bindkey '\er' fzf-history-widget

        bindkey -a '\ef' fzf-file-widget
        bindkey '\ef' fzf-file-widget

        source $HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh
        # zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
        zstyle ':fzf-tab:*' use-fzf-default-opts yes

        bindkey '^O' autosuggest-accept
        source $HOME/.zsh_functions_and_widgets
}

zvm_after_init_commands+=(my_init)
#################################################################################

alias ls='ls --color=always'
alias kc="kubectl"

PATH=$PATH:$HOME/.local/bin

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

if command -v nvim >/dev/null; then
        export EDITOR='nvim -f'
        export KUBE_EDITOR='nvim -f'
        export MANPAGER="nvim +Man!"
elif command -v bat >/dev/null; then
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if command -v warp-cli >/dev/null; then
        source <(warp-cli generate-completions zsh)
fi

if command -v golangci-lint >/dev/null; then
        source <(golangci-lint completion zsh)
fi
if command -v dlv >/dev/null; then
        source <(dlv completion zsh)
fi
if command -v kubectl >/dev/null; then
        source <(kubectl completion zsh)
fi
if command -v helm >/dev/null; then
        source <(helm completion zsh)
fi

if command -v zoxide >/dev/null; then
        alias cd='z'
        eval "$(zoxide init zsh)"
else
        echo "zoxide not found"
fi
