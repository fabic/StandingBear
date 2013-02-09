#
# F.2011-08-16 : From LFS (http://www.linuxfromscratch.org/blfs/view/stable/postlfs/profile.html)
#

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
    local IFS=':'
    local NEWPATH
    local DIR
    local PATHVARIABLE=${2:-PATH}
    for DIR in ${!PATHVARIABLE} ; do
        if [ "$DIR" != "$1" ] ; then
            NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
        fi
    done
    export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
    pathremove $1 $2
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
    pathremove $1 $2
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

# End of BLFS imported stuff.
###

##
# For prefixed-installed stuff, such as 
#    /opt/thing-1.2.3/{bin,include,lib,share/man,share/info,...}/
prefixed_paths () {
    local PREFIX="$1"
    # Realpath, good/bad ??
    #local PREFIX=$(cd -P "$1" && pwd)
    if [ ! -e "$PREFIX" ]; then
        #echo "$0 : Warning: \`$' prefix not found."
        continue
    fi

    # PATH
    [ -d "$PREFIX/bin" ] && pathprepend "$PREFIX/bin"

    # LD_LIBRARY_PATH
    #
    # Commented out, seems not be a good idea apparently (see http://xahlee.org/UnixResource_dir/_/ldpath.html),
    # and hopefully those custom-built software get rpath-ed somehow, /me guess.
    #
    #[ -d "$PREFIX/lib"   ] && pathprepend "$PREFIX/lib" LD_LIBRARY_PATH
    #[ -d "$PREFIX/lib64" ] && pathprepend "$PREFIX/lib64" LD_LIBRARY_PATH

    # todo: What about LD_RUN_PATH ?

    # INCLUDE
    [ -d "$PREFIX/include" ] && pathprepend "$PREFIX/include" INCLUDE

    # MANPATH
    [ -d "$PREFIX/share/man" ] && pathprepend "$PREFIX/share/man" MANPATH
    [ -d "$PREFIX/man"       ] && pathprepend "$PREFIX/man" MANPATH

    # INFOPATH
    [ -d "$PREFIX/share/info" ] && pathprepend "$PREFIX/share/info" INFOPATH
}
