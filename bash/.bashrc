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
# Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.10.2.app"
if [ -d "$GHC_DOT_APP" ]; then
  export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi
# Add /usr/local to PATH
export PATH="/usr/local/bin:${PATH}"
# google depot tools
export PATH=$PATH:~/bin/depot_tools
# GO
export PATH=/usr/local/go/bin:$PATH
# POSTGRES
# DATA /Users/cpc26/Library/Application Support/Postgres/var-9.5
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
