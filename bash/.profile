if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
# Interactive Shell Specific
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

export EDITOR="emacsclient --alternate-editor zile"

#Java
export JAVA_HOME=$(/usr/libexec/java_home)

source ~/.xsh

