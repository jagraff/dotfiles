source /etc/profile
function gcb() {
        current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo " $current_branch "
        else
                echo "[-]"
        fi
}

PROMPT_DIRTRIM=3

SMALLPROMPT=0

function fetch_context() {
    KUBECTL_CONTEXT=$(kubectl config current-context)
}

function toggle() {
    if [ $SMALLPROMPT != 1 ]; then
        SMALLPROMPT=1
    else
        SMALLPROMPT=0
    fi
}

function k_context() {
    local curr_context=$KUBECONFIG
    echo "$curr_context" | awk '{ split($1, cmpts, "-"); print(cmpts[2]) }'
}

function is_prod_context() {
    echo $KUBECTL_CONTEXT | ag "whitesnake|aerosmith"
}

function is_prod_k8s_dir() {
    pwd | ag "kube-manifests.*prod"
}

function is_k8s_dir() {
    pwd | ag "kube-manifests"
}

Green='\[\e[0;32m\]'
Yellow='\[\e[0;33m\]'
Red='\[\e[0;31m\]'
Blue='\[\e[0;34m\]'
White='\[\e[0;37;0m\]'
Magenta='\[\e[0;95m\]'
Reset='\[\e[m\]'

GreenOnBlack='\[\e[0;32;40m\]'
YellowOnBlack='\[\e[1;33;40m\]'
RedOnBlack='\[\e[0;31;40m\]'
BlueOnBlack='\[\e[0;34;40m\]'
WhiteOnBlack='\[\e[0;37;40m\]'

BlackOnGreen='\[\e[0;30;42m\]'
BlackOnYellow='\[\e[0;30;43m\]'
BlackOnRed='\[\e[1;30;41m\]'
BlackOnBlue='\[\e[0;30;44m\]'
BlackOnWhite='\[\e[0;30;47m\]'

BlueOnGreen='\[\e[0;34;42m\]'

WhiteOnGreen='\[\e[1;37;45m\]'
WhiteOnBlue='\[\e[1;35;40m\]'

GreenOnWhite='\[\e[0;32;47m\]'
RedOnWhite='\[\e[0;31;47m\]'


function clean_dir_string() {
    local cleaned=$(pwd  | sed -e 's/\/Users\/jacobgraff\/git\/giphy\/giphy-services/~\/g\/g\/g/g')

    echo $cleaned | egrep "~"
}


function __my_prompt_command() {
	local EXIT="$?"

    local clock_color=$BlueOnBlack
    local dir_color=$WhiteOnBlue
    local git_color=$YellowOnBlack
    local k8s_color=$GreenOnBlack
    local exit_color=$BlackOnRed
    local prompt_color=$White
    local default_color=$WhiteOnBlack

    fetch_context

    if [ $(is_prod_context) ]; then
        k8s_color=$RedOnWhite
        if [ -z $(is_prod_k8s_dir) ]; then
            dir_color=$BlackOnRed
        fi
    else
        if [ $(is_prod_k8s_dir) ]; then
            dir_color=$BlackOnRed
        fi
    fi

    local clock_s="${clock_color} \D{%T} "
    local k8s_s="${k8s_color} $(k_context) "
    local dir_s="${dir_color} \w "
    local prompt_s="${prompt_color}\$"
    local nl_s="${White}${RESET}\n"

    if [ $EXIT != 0 ]; then
        local exit_s="${exit_color} ${EXIT} "
    fi

    local gcb_output=$(gcb)

    if [ $gcb_output != "[-]" ]; then
        git_color=$BlackOnYellow
    fi

    local cleaned=$(clean_dir_string) 
    if [ $cleaned ]; then
        dir_s="${dir_color} ${cleaned} "
    fi

    local git_s="${git_color}${gcb_output}"

    PS1="${clock_s}${git_s}${k8s_s}${exit_s}${nl_s}${dir_s}${nl_s}${prompt_s} "
}

shopt -s checkwinsize
export PROMPT_COMMAND=__my_prompt_command

# disable the most irritating terminal emulation feature ever known
stty -ixon

# vi bindings are great everywhere
set -o vi

# this bundle of joy is for portable LS colors.
# I like yellow dictories because bold blue is
# impossible to see on an osx terminal
unamestr=$(uname | tr '[:upper:]' '[:lower:]')
if [ $unamestr == 'linux' ] ; then
	alias ls="ls --color=auto"
	export LS_COLORS='di=33'
elif [ $unamestr == 'darwin' ] ; then
    alias ls="ls -G"
    export CLICOLOR=1
    export LSCOLORS="DxGxcxdxCxegedabagacad"
else
    alias ls="ls"
    echo "Problem setting ls colors, uname = $unamestr"
fi

# ag rage
alias ag="ag -if"

alias grep="grep --color=auto"

# random tools
alias copen='open -a "Google Chrome"'
alias plot='/Users/jacobgraff/git/chriswolfvision/eplot/eplot -d 2>/dev/null'

# use vimdiff for git diffs so they don't suck
alias gitdiff='git difftool --tool=vimdiff'

alias io="iostat -xk 1"
alias vi="vim"
alias emacs="emacs -nw"
alias jmux="tmux -S /tmp/john.tmux"
export EDITOR=vim

# interactive for safety
alias mv="mv -i"
alias ln="ln -i"
alias cp="cp -i"

unalias ll 2>/dev/null

function ll() {
	COLOR_COMMAND="lolcat -r -h 1 -v 1"
	ls -alF "$@" | eval "$COLOR_COMMAND"; 
}

# ls alias
alias l='ls'
alias lc='ll | cowsay -n'

# I don't want to type .. a lot
alias ..='cd ..'
alias gs='cd ~/git/giphy/giphy-services'

# K8S contexts
export KUBECONFIG=~/.kube/config-hanson

alias k=kubectl
alias hanson='export KUBECONFIG=~/.kube/config-hanson'
alias snek='export KUBECONFIG=~/.kube/config-whitesnake'
alias aero='export KUBECONFIG=~/.kube/config-aerosmith'


export GS="~/git/giphy/giphy-services"

alias spp="$(git rev-parse --show-toplevel 2> /dev/null)/scripts/set_pants_python.sh"
alias sps="$(git rev-parse --show-toplevel 2> /dev/null)/scripts/set_pants_scala_2_12.sh"


# i'm used to this now
unalias reset &>/dev/null
alias realreset="$(which reset)"
alias reset="source $HOME/.bashrc && clear"

# stolen from /etc/profile
function pathmunge {
    if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

export PATH="/bin:/usr/bin"
pathmunge "/sbin"
pathmunge "/usr/sbin"
pathmunge "/usr/local/bin" 
pathmunge "/usr/local/sbin" 
pathmunge "$HOME/local/bin" 
pathmunge "/usr/games"
pathmunge "/opt/labrat/bin"
pathmunge "/Users/jacobgraff/Library/Python/3.7/bin/"


export PATH=$PATH:/opt/backtrace/bin
export PATH="$PATH:/Users/jacobgraff/.pyenv/bin"
export PATH="$PATH:$(pyenv root)/versions/3.6.8/bin"


export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib64:/usr/lib64:/usr/local/adnxs/lib:$HOME/local/lib:/usr/local/lib:$LD_LIRARY_PATH"
export C_INCLUDE_PATH="/usr/local/adnxs/include:$HOME/local/include:/usr/local/include:$C_INCLUDE_PATH"


export RATSODA_PATH="/home/jgraff/git/appnexus/ratsoda"
export LUA_PATH="/usr/include/rtp-messages/?.lua;${RATSODA_PATH}/ratsoda/interpreter/lua/?.lua;${RATSODA_PATH}/common/?.lua;${RATSODA_PATH}/build/bpgen/?.lua"

shopt -s histappend
export HISTIGNORE="ls:cd ~:cd ..:exit:h:history"
export HISTCONTROL="erasedups"
#export PROMPT_COMMAND="history -a" # so history flushes after each command

function h {
    pattern=$1
    history | grep $pattern
}

# ugh
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;

export VAULT_ADDR=https://vault.giphy.tech

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jacobgraff/google-cloud-sdk/path.bash.inc' ]; then . '/Users/jacobgraff/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jacobgraff/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/jacobgraff/google-cloud-sdk/completion.bash.inc'; fi
