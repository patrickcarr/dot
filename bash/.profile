if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
# Interactive Shell Specific
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
# GIT
. ~/.git-completion.bash
. ~/bin/git-prompt.sh
# The following line ensures that history logs screen commands as well
shopt -s histappend
# This line makes the history file to be rewritten and reread at each bash prompt
prompt_command (){
    history -a
    HISTFILESIZE=100000     # start truncating commands after 100000 lines
    history -c
    history -r
}
export PROMPT_COMMAND=prompt_command
# Have lots of history
HISTSIZE=100000         # remember the last 100000 commands
HISTCONTROL=ignoreboth  # ignoreboth is shorthand for ignorespace and ignoredups
PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
export EDITOR="emacsclient --alternate-editor zile"

#Java
export JAVA_HOME=$(/usr/libexec/java_home)

source ~/.xsh

