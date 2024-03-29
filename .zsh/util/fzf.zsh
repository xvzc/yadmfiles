#!/bin/zsh
# alias fcd='cd $(fd --type d --search-path=$HOME/_jry | fzf)'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
#fzf option
export FZF_DEFAULT_OPTS="--layout=reverse \
  --inline-info \
  --height 40% \
  --preview 'bat --style=numbers --color=always --line-range :500 {}' \
  --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
  "

export FZF_TMUX_OPTS='-p80%,60%'

# export FZF_CUSTOM_OPTS=( \
#   --layout=reverse \
#   --inline-info \
#   --height 40%  \
#   --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
# )

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
# export ='--border --info=inline'
# export FZF_COMPLETION_OPTS="--layout=reverse \
#                             --inline-info \
#                             --height 40%  \
#                             --preview 'bat --style=numbers --color=always --line-range :500 {}' \
#                             --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
#                            "

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

function fvi() {
  OUTPUT=$( \
  fd -L --type f --hidden --follow --exclude .git $1 | \
    fzf \
    --preview 'bat --style=numbers --color=always --line-range :500 {}' \
    --query=$1 \
  )

  if [[ ! -z $OUTPUT ]]; then
    vi $OUTPUT
  fi
}

function fcd() {
  OUTPUT=$( \
    fd -L --type d --hidden --search-path=$HOME | \
    fzf \
    --preview='tree {}' \
    --query=$1 \
  )

  if [[ ! -z $OUTPUT ]]; then
    cd $OUTPUT
  fi
}

function fif() {
  if [ ! "$#" -gt 0 ]; then echo "patterns"; return 1; fi
  rg --files-with-matches --no-messages $2 "$1" | fzf\
  --border\
  --height 80%\
  --extended\
  --ansi\
  --reverse\
  --cycle\
  --header 'Find in File'\
  --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'\
  --bind 'alt-p:preview-up,alt-n:preview-down'\
  --bind 'ctrl-u:half-page-up,ctrl-d:half-page-down'\
  --bind '?:toggle-preview,alt-w:toggle-preview-wrap'\
  --bind 'alt-v:execute(nvim {} >/dev/tty </dev/tty)'\
  --preview "bat --theme='OneHalfDark' --style=numbers --color=always {} | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

git-commit-show () {
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"  | \
   fzf --ansi --no-sort --reverse --tiebreak=index --preview \
   'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
   --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=right:60%
}

