source /etc/profile
function gcb() {
        current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo $current_branch
        else
                echo ""
        fi
}

#PROMPT_DIRTRIM=3

function __my_prompt_command() {
	local EXIT="$?"
	PS1=""
	local Green='\[\e[0;32m\]'
	local Yellow='\[\e[0;33m\]'
	local Red='\[\e[0;31m\]'
	local Reset='\[\e[m\]'

	PS1+="${Green}[\w]${Reset} "
	PS1+="${Yellow}[$(gcb)]${Reset} "

	if [ $EXIT != 0 ]; then
		PS1+="${Red}[${EXIT}] $ ${Reset}"
	else
		PS1+="$ "
	fi
}

export PROMPT_COMMAND=__my_prompt_command

# prompt colors and git
 export PS1='[\[\e[0;33m\]\[\e[m\]\[\e[0;32m\]\w\[\e[m\]] \[\e[0;33m\][$(gcb)]\[\e[m\] $ '

# disable the most irritating terminal emulation feature ever known
stty -ixon

# vi bindings are great everywhere except the command line
set -o emacs

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


export PATH=$PATH:/opt/backtrace/bin


export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib64:/usr/lib64:/usr/local/adnxs/lib:$HOME/local/lib:/usr/local/lib:$LD_LIRARY_PATH"
export C_INCLUDE_PATH="/usr/local/adnxs/include:$HOME/local/include:/usr/local/include:$C_INCLUDE_PATH"

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
