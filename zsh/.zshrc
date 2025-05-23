# Enable Powerlevel10k instant prompt. Should stay close to the top of $HOME/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

WORDCHARS='*?[]~=\ -_&;!#$%^(){}<>/|'

autoload -Uz compinit
compinit

source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' use-fzf-default-opts yes

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-historykk
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -a "k" .up-line-or-history
bindkey -a "j" .down-line-or-history

bindkey -M menuselect '\e' send-break
bindkey -M menuselect '^N' down-line-or-history
bindkey -M menuselect '^P' up-line-or-history

source <(kubectl completion zsh)

bindkey -v

KEYTIMEOUT=1

fpath=($HOME/.zsh/zsh-completions/src $fpath)

setopt AUTO_CD
setopt AUTO_PUSHD
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt AUTO_PARAM_SLASH
setopt LIST_PACKED

HISTFILE=$HOME/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
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
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source ~/.p10k.zsh

source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme

ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=100
bindkey '^o' autosuggest-accept

source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

source $HOME/.zsh/.zsh-vi-mode/zsh-vi-mode.plugin.zsh
ZVM_CURSOR_STYLE_ENABLED=false

function my_init() {
  [ -f $HOME/.fzf.zsh ] && source ~/.fzf.zsh
  export FZF_DEFAULT_COMMAND='fd --hidden --color=always'
  export FZF_DEFAULT_OPTS="--ansi ${FZF_DEFAULT_OPTS} --multi"
  export FZF_DEFAULT_OPTS="--bind='ctrl-y:accept' ${FZF_DEFAULT_OPTS}"
  export FZF_PREVIEW_FILE_CMD='bat --color=always --style=numbers --line-range=:500'

  bindkey -a '\er' fzf-history-widget
  bindkey '\er' fzf-history-widget

  bindkey -a '\ef' fzf-file-widget
  bindkey '\ef' fzf-file-widget

  fzf-dir-widget() {
    local dir
    dir=$(fd --type d --hidden --exclude .git | fzf --ansi --preview 'ls -l {}' --preview-window=right:40%) || return
    LBUFFER+="$dir"
    zle reset-prompt
  }
  zle -N fzf-dir-widget
  bindkey -a '\ed' fzf-dir-widget
  bindkey '\ed' fzf-dir-widget

  exactgrep() {
    RG_PREFIX="rg --hidden --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --delimiter : \
        --preview 'filename={1}; lineno={2}; start=$(( lineno > 10 ? lineno - 10 : 1 )); end=$(( lineno + 10 )); bat --color=always --highlight-line "$lineno" --line-range "${start}:${end}" "$filename"' \
        --preview-window 'right:50%' \
        --bind 'ctrl-y,enter:become(nvim {1} +{2})'
  }

  zle -N exactgrep
  bindkey -a '\eg' exactgrep
  bindkey '\eg' exactgrep

  fuzzygrep() {
    local dir="${1:-.}"
    rg --hidden --column --line-number --color=always --no-heading "" "$dir"\
      | fzf --multi --ansi --delimiter : --preview 'filename={1}; lineno={2}; start=$(( lineno > 10 ? lineno - 10 : 1 )); end=$(( lineno + 10 )); bat --color=always --highlight-line "$lineno" --line-range "${start}:${end}" "$filename"' --preview-window right:50% --bind 'ctrl-y,enter:become(nvim {1} +{2})'
  }
 
  zle -N fuzzygrep
  bindkey -a '^G' fuzzygrep
  bindkey '^G' fuzzygrep

  bindkey -M viins '^N' fzf-tab-complete
  bindkey -M viins '^P' fzf-tab-complete

  function backward-kill-word-strict() {
    local wordchars="$WORDCHARS"
    local i=${#LBUFFER}
    local first=true
    local delete_space=false
    while (( i > 0 )); do
      local c="${LBUFFER[i]}"
      if [[ "$c" == " " ]]; then
        if [[ "$first" == true ]]; then
          delete_space=true
        elif [[ "$delete_space" != true ]]; then
          break
        fi
      else
        if [[ "$delete_space" == true ]]; then
          break
        fi
        delete_space=false
      fi
      if [[ "$wordchars" != *"$c"* || (("$delete_space" == true && "$c" == " ")) ]]; then
        ((i--))
      elif [[ "$first" == true ]]; then
        ((i--))
        break
      else
        break
      fi
      first=false
    done
    LBUFFER="${LBUFFER[1,i]}"
  }

  zle -N backward-kill-word-strict
  bindkey '^W' backward-kill-word-strict

  yazi_widget() {
    yazi </dev/tty >/dev/tty 2>&1
  }
  zle -N yazi_widget
  bindkey -a '^Y' yazi_widget
  bindkey '^Y' yazi_widget

  fg_or_suspend() {
    if jobs % 2>/dev/null | grep -iq 'suspended'; then
      fg
      zle reset-prompt
    else
      zle send-break
    fi
  }

  zle -N fg_or_suspend
  bindkey '^Z' fg_or_suspend
}

zvm_after_init_commands+=(my_init)
my_init
#################################################################################

alias tns='tmux new -t'
alias fp='fzf -m --preview "batcat --color=always --style=numbers --line-range=:500 {}"'
alias zp='z $(zoxide query -l | fzf)'
alias cd='z'
alias i3l="i3lock -uc 000000"
alias ls='ls --color=always'
alias gl="git log --oneline -5"
alias kc="kubectl"

dockerclean() {
  docker kill $(docker ps -aq)
  docker system prune --all
}

dockerrmi() {
  if (($# == 0)); then
    echo "Usage: dockerrmi <pattern1> <pattern2> or dockerrmi <pattern1,pattern2,...>"
    echo "Patterns are case-insensitive and matched against the full image name."
    return 1
  fi

  local patterns_array=()
  for arg in "$@"; do
    patterns_array+=( "${arg//,/|}" )
  done

  local final_pattern
  IFS='|' final_pattern="${patterns_array[*]}"

  docker images | awk -v pattern="$final_pattern" '
    BEGIN { IGNORECASE = 1 }
    $1 ~ pattern || $2 ~ pattern { print $3 }
  ' | xargs -r docker rmi -f
}

pskill() {
  if (($# == 0)); then
    echo "Usage: pskill <pattern1> <pattern2> or pskill <pattern1,pattern2,...>"
    echo "Patterns are case-insensitive and matched against the full command line."
    return 1
  fi

  local patterns_array=()
  for arg in "$@"; do
    patterns_array+=( "${arg//,/|}" )
  done

  local final_pattern
  IFS='|' final_pattern="${patterns_array[*]}"

  ps aux | awk -v pat="$final_pattern" '
    BEGIN { IGNORECASE = 1 }
    $11 ~ pat { print $2 }
  ' | xargs -r sudo kill -9
}

killports() {
  if (($# == 0)); then
    echo "Usage: killports <pattern1> <pattern2> or killports <pattern1,pattern2,...>"
    echo "Patterns are case-insensitive and matched against the full image name."
    return 1
  fi
  local ports=$(IFS=, ; echo "$*")
  echo "Killing ports $ports"
  sudo kill -9 $(sudo lsof -ti :"$ports")
}

PATH=$PATH:$HOME/.local/bin

export REGISTRY=sami7786

export EDITOR='nvim -f'
export KUBE_EDITOR='nvim -f'

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

export JAVA_HOME=/usr/lib/jvm/jdk
export PATH=$JAVA_HOME/bin:$PATH

export MAVEN_HOME=/usr/lib/mvn/maven
export PATH=$MAVEN_HOME/bin:$PATH

FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

eval "$(zoxide init zsh)"
