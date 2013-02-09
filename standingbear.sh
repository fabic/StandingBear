##
# standingbear.sh
#
# Designed for being sourced by Sh scripts, hence by doing something like :
#    source `dirname $0`/standingbear.sh
#
# May also be run, e.g. :
#   $ sh standingbear.sh
# which would have the environment setup hereinbelow be displayed.
#
#
# todo: Removing trailling slashes from paths ?
# todo: Prepend *PATH with stuff in local/ ?
# todo: have a check_path_correct() func. ?
# todo: test/debug if spaces in paths.
#
HERE=$( cd `dirname "$0"` && pwd )

[ "x$StandingBear" != "x" ] && return

StandingBear=$( cd `dirname "${BASH_SOURCE[0]}"` && pwd )


source "$StandingBear/functions.sh"

pathprepend "$StandingBear/bin"

# Source early local environment customizations :
[ -r "$StandingBear/standingbear.prologue.sh" ] &&
    source "$StandingBear/standingbear.prologue.sh"

LANG=${LANG:-C}

#unset SSH_CLIENT
APACHE_AdminIp=${APACHE_AdminIp:-${SSH_CLIENT%% *}}
APACHE_AdminIp=${APACHE_AdminIp:-127.0.0.1}

APACHE_ServerRoot=${APACHE_ServerRoot:-$StandingBear}
APACHE_ConfigFile=${APACHE_ConfigFile:-conf/httpd.conf}

# fixme/todo: auto setup if /usr or /usr/local & if not usr, such as /opt ?
# Ex. write a guess_apache_thing() function ?
#APACHE_Home=${APACHE_Home:-$APACHE_ServerRoot/local/apache}
APACHE_Home=${APACHE_Home:-/usr}

# Temp.: Simple paths "guessing".
if [ "x${APACHE_Home#/usr}" == "x" ]; then
    # A typical LSB layout :
    APACHE_Httpd=${APACHE_Httpd:-/usr/sbin/apache2}
    APACHE_Modules=${APACHE_Modules:-/usr/lib/apache2/modules}
    APACHE_Manual=${APACHE_Manual:-`ls -1d /usr/share/doc/apache-*/manual`}
    APACHE_ErrorDocuments=${APACHE_ErrorDocuments:-/usr/share/apache2/error}
    APACHE_Icons=${APACHE_Icons:-/usr/share/apache2/icons}
else
    # A typical hand-built Apache installed in a dedicated location
    # such as /opt/apache-2.2.23/ :
    APACHE_Httpd=${APACHE_Httpd:-$APACHE_Home/bin/httpd}
    APACHE_Modules=${APACHE_Modules:-$APACHE_Home/modules}
    APACHE_Manual=${APACHE_Manual:-$APACHE_Home/manual}
    APACHE_ErrorDocuments=${APACHE_ErrorDocuments:-$APACHE_Home/error}
    APACHE_Icons=${APACHE_Icons:-$APACHE_Home/icons}
fi

APACHE_RUN_USER=${APACHE_RUN_USER:-`id -nu`}
APACHE_RUN_GROUP=${APACHE_RUN_GROUP:-`id -nu`}

APACHE_HostDomain=${APACHE_HostDomain:-`hostname -d`}
APACHE_Hostname=${APACHE_Hostname:-`hostname -f`}
APACHE_ListenPort=${APACHE_ListenPort:-8000}
APACHE_ListenPortSSL=${APACHE_ListenPortSSL:-8001}

APACHE_ModPhp5SO=${APACHE_ModPhp5SO:-$APACHE_Modules/libphp5.so}

# fixme: temp.?
# todo: s/PHPBIN/PHP_Bin/ ?
PHPBIN=${PHPBIN:-`which php`}
PHPINI=${PHPINI:-$StandingBear/php/php.ini}

# Array of environment variable names that are to be imported into the "empty
# env." (See $Env) :
Environment=( StandingBear ${!APACHE@} LANG PATH LD_LIBRARY_PATH )

# fixme: Yes, no, why actually ?
export ${Environment[@]}

# Source late local environment customizations :
[ -r "$StandingBear/standingbear.epilogue.sh" ] &&
    source "$StandingBear/standingbear.epilogue.sh"

#
# Build $Env :
#
Env="env -i "
for e in "${Environment[@]}"; do
    Env="$Env $e=${!e}"
done

#
# Display environment if we're being run :
# todo: have it be a sb_display_env()?
#
if [ `basename "$0"` == "${BASH_SOURCE[0]}" ]; then
    for e in "${Environment[@]}"; do
        echo -n '   '
        echo $e=${!e}
    done | column -t -s '='
fi
# vim: ts=4 filetype=sh
