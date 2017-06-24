#add $HOME/bin in front
export PATH="${HOME}/bin:${PATH}"
test -r /sw/bin/init.sh && . /sw/bin/init.sh
export CFLAGS=-I/sw/include 
export LDFLAGS=-L/sw/lib 
export CXXFLAGS=$CFLAGS 
export CPPFLAGS=$CXXFLAGS 
export ACLOCAL_FLAGS="-I /sw/share/aclocal"
export PKG_CONFIG_PATH="/sw/lib/pkgconfig"
export PATH=/sw/var/lib/fink/path-prefix-10.6:$PATH
export MACOSX_DEPLOYMENT_TARGET=10.5
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
# Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.10.2.app"
if [ -d "$GHC_DOT_APP" ]; then
  export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi
# haskell stack
export PATH="/Users/cpc26/.stack/programs/x86_64-osx/ghc-7.10.2/bin:${PATH}"
eval "$(stack --bash-completion-script stack)"
# Add /usr/local to PATH
export PATH="/usr/local/bin:${PATH}"
# google depot tools
export PATH=$PATH:~/bin/depot_tools
# GO
export PATH=/usr/local/go/bin:$PATH
# POSTGRES
# DATA /Users/cpc26/Library/Application Support/Postgres/var-9.5
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

PATH="/Users/cpc26/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/Users/cpc26/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/cpc26/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/cpc26/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/cpc26/perl5"; export PERL_MM_OPT;

# added by Anaconda2 4.3.1 installer
export PATH="/Users/cpc26/anaconda2/bin:$PATH"

# source ~/.xsh

