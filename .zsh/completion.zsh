#!/bin/zsh

# Initialize the autocompletion
# skip_global_compinit=1

# Do menu-driven completion.
zstyle ':completion:*' menu select
zstyle ':completion:*:*:git:*' user-commands login:'git_login' \
  list-pr:'hub_list_pr' \
  make-pr:'hub_make_pr' \
  merge-pr:'hub_make_pr'

# formatting and messages
zstyle ':completion:*' verbose yes
# zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
# zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:warnings' format "No matches"
# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# zstyle ':completion:*' group-name ''

# Completers for my own scripts
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

zstyle ':completion:*' list-colors "${LS_COLORS}"


# Better SSH/Rsync/SCP Autocomplete
# zstyle ':completion:*:ssh:*' hosts off
# zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
# zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users

# Speed up zsh compinit by only checking cache once a day.
# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit -i
# done


