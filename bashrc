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

function toggle() {
    if [ $SMALLPROMPT != 1 ]; then
        SMALLPROMPT=1
    else
        SMALLPROMPT=0
    fi
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
WhiteOnBlue='\[\e[1;37;46m\]'

GreenOnWhite='\[\e[0;32;47m\]'

function __my_prompt_command() {
	local EXIT="$?"

    local clock_color=$BlueOnBlack
    local dir_color=$BlackOnGreen
    local git_color=$YellowOnBlack
    local exit_color=$BlackOnRed
    local prompt_color=$White
    local default_color=$WhiteOnBlack


    local clock_s="${clock_color}\D{%T} "
    local dir_s="${dir_color} \w "
    local prompt_s="${prompt_color}\$"

    if [ $EXIT != 0 ]; then
        local exit_s="${exit_color} ${EXIT} "
    fi

    local gcb_output=$(gcb)

    if [ $gcb_output != "[-]" ]; then
        git_color=$BlackOnYellow
    fi

    local git_s="${git_color}${gcb_output}"

    PS1="${clock_s}${git_s}${dir_s}${exit_s}${White}${RESET}\n${prompt_s} "
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

# ls alias
alias ll='ls -alF'
alias l='ls'
alias lc='ll | cowsay -n'

# I don't want to type .. a lot
alias cb='cd ..'
alias ..='cd ..'

# i'm used to this now
unalias reset &>/dev/null
alias realreset="$(which reset)"
alias reset="source $HOME/.bashrc && clear"

alias copen="open -a 'Google Chrome'"

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
pathmunge "/opt/homebrew/bin"
pathmunge "/sbin"
pathmunge "/usr/sbin"
pathmunge "/usr/local/bin" 
pathmunge "/usr/local/sbin" 
pathmunge "$HOME/local/bin" 
pathmunge "/usr/games"
pathmunge "/opt/labrat/bin"
pathmunge "/Users/jacobgraff/Library/Python/3.7/bin/"


export PATH=$PATH:/opt/backtrace/bin


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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PATH="$HOME/.local/bin:$PATH"
