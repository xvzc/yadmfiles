#!/bin/zsh

# utils
function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done

}

# "vi FILE_NAME" automatically runs "chemoi edit FILE_NAME" command if the file is under management by chemoi.
# otherwise just give the all arguments to neovim
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo "%{\$fg[white]%}[$(basename $VIRTUAL_ENV)]%{$reset_color%}";
}

# "vi FILE_NAME" automatically runs "chemoi edit FILE_NAME" command if the file is under management by chemoi.
# otherwise just give the all arguments to neovim
# function vi() {
#   if [ $# -eq 0 ]; then
#     nvim
#     return
#   fi
#
#   # Added "--hardlink=false" option to get neovim undo available.
#   chezmoi verify $1 > /dev/null 2>&1 \
#     && chezmoi edit --watch --hardlink=false $1 \
#     || nvim $@
# }

function push() {
  git add .
  if [ -z "$1" ]
  then
    git commit -a -m "No commit message"
  else
    git commit -a -m "$1"
  fi
  git push
}

# init functions
# conda
function init_conda(){
    __conda_setup="$('$HOME/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/opt/anaconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/opt/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/opt/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
}

# rbenv
function init_rbenv(){
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
    export PATH="$HOME/.rbenv/bin:$PATH"
    export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
    eval "$(rbenv init -)" #changed this to below because of slow startup
}

# jenv
function init_jenv(){
    # export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_271.jdk/Contents/Home
    export PATH=${PATH}:$JAVA_HOME/bin
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
}

# virtualenv
function init_virtualenv(){
    ## virtualEnv Wrapper
    export WORKON_HOME=~/.virtualenvs
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
    export VIRTUALENVWRAPPER_VIRTUALENV=$(which virtualenv)
    source /usr/local/bin/virtualenvwrapper.sh
}

# gvm
function init_gvm(){
    [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
}

# nvm 
function init_nvm(){
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}

# yvm
function init_yvm(){
    export YVM_DIR=$HOME/.yvm
    [ -r $YVM_DIR/yvm.sh ] && . $YVM_DIR/yvm.sh
}

# sdkman
function init_sdkman(){
    #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
}

function run_tmux_on_cases(){
    GOGOSING=$(ps -p $(ps -p $$ -o ppid=) -o args=)
    if [[ $CUR_OS == 'linux' ]] && [[ $GOGOSING =~ 'tilda' ]]; then
        if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            tmux new-session -A -s tilda
        else
            return
        fi
    elif [[ $CUR_OS == 'mac' ]] && [[ $GOGOSING =~ 'alacritty' ]]; then
        if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
            tmux new-session -A -s alacritty
        else
            return
        fi
    fi
}

function bojlogin() {
    mkdir -p $HOME/.boj-cli
    touch $HOME/boj-handle
    touch $HOME/boj-token
    echo "$1" > $HOME/.boj-cli/boj-handle
    echo "$2" > $HOME/.boj-cli/boj-token
}
