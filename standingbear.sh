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
# $Env is built herein and may be used for running things in an
# uncluttered environment; See e.g. apachectl, or bin/php.
#
# todo: have an unexpectedly empty env var check func.
# todo: Have ap_env_push() that may be used to customize the empty env. from prologue/epilogue.
# todo: Removing trailling slashes from paths ?
# todo: have a check_path_correct() func. ?
# todo: test/debug if spaces in paths.
# todo: chdir bef exec ?
#

# For scripts to have their location at hands-reach :
HERE=$( cd `dirname "$0"` && pwd )

# Prevent from being included several times :
[ "x$StandingBear" != "x" ] && return

# Whence we stand :
StandingBear=$( cd `dirname "${BASH_SOURCE[0]}"` && pwd )

# Utility functions :
source "$StandingBear/functions.sh"

pathprepend "$StandingBear/bin"

# Source early local environment customizations :
[ -r "$StandingBear/standingbear.prologue.sh" ] &&
    source "$StandingBear/standingbear.prologue.sh"

LANG=${LANG:-C}

# See conf/httpd.local.conf about Apache env. var. `let_me_in` :
APACHE_AdminIp=${APACHE_AdminIp:-${SSH_CLIENT%% *}}
APACHE_AdminIp=${APACHE_AdminIp:-127.0.0.1}

APACHE_ServerRoot=${APACHE_ServerRoot:-$StandingBear}
APACHE_ConfigFile=${APACHE_ConfigFile:-conf/httpd.conf}

# fixme/todo: auto setup if /usr or /usr/local & if not usr, such as /opt ?
# Ex. write a guess_apache_thing() function ?
#APACHE_Home=${APACHE_Home:-$APACHE_ServerRoot/local/apache}
APACHE_Home=${APACHE_Home:-/usr}

# fixme: temp.: Simple Apache paths "guessing".
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

# todo: change case (_RunUser, _RunGroup).
APACHE_RUN_USER=${APACHE_RUN_USER:-`id -nu`}
APACHE_RUN_GROUP=${APACHE_RUN_GROUP:-`id -nu`}

# Note: May evaluate to ""
APACHE_HostDomain=${APACHE_HostDomain:-`hostname -d`}

APACHE_Hostname=${APACHE_Hostname:-`hostname -f`}
APACHE_ListenPort=${APACHE_ListenPort:-8000}
APACHE_ListenPortSSL=${APACHE_ListenPortSSL:-8001}

# See conf/mods-available/php5.conf
APACHE_ModPhp5SO=${APACHE_ModPhp5SO:-$APACHE_Modules/libphp5.so}

# Defaults LDAP URL is built with:
#   * ldap:// scheme  (port 389)
#   * Reaching the server from the loopback interface (hence 127.0.0.1) :
#   * Base DN is build from the domain name broken down into Domain Components (dc=) :
#   * Searching of everything (objectClass=*) that has an 'uid' attribute.
# See conf/mods-available/ldap.conf
basedn=( `echo "$APACHE_HostDomain" | tr '.' ' '` ); basedn=${basedn[@]/#/dc=}; basedn=${basedn// /,};
APACHE_LdapAuthURL=${APACHE_LdapAuthURL:-"ldap://127.0.0.1:389/$basedn?uid?sub?(objectClass=*)"}
unset basedn

# fixme: temp.?
# todo: s/PHPBIN/PHP_Bin/ ?
PHPBIN=${PHPBIN:-`which php`}
PHPINI=${PHPINI:-$StandingBear/php/php.ini}

# Used in monitor_access_log.sh
CCZEBIN=`which ccze`

# Array of environment variable names that are to be imported into the
# "empty env." (See $Env) :
Environment=( StandingBear "${!APACHE@}" LANG PATH LD_LIBRARY_PATH )

# Source late local environment customizations, e.g. for a chance of customizing
# $Environment without having to mess up here :
[ -r "$StandingBear/standingbear.epilogue.sh" ] &&
    source "$StandingBear/standingbear.epilogue.sh"

#
# Build $Env
#
# Empty variables get assigned 'nil' here, for emtpy things fuck up Apache
# conf. statements too much.
#
Env="env -i "
for e in "${Environment[@]}"; do
    declare $e=${!e:=nil}
    Env="$Env $e=${!e}"
done

# fixme: Yes, no, why actually ?
export ${Environment[@]}

#
# Display environment if we're being run :
# todo: have it be a sb_display_env()?
#
if [ `basename "$0"` == "${BASH_SOURCE[0]}" ]; then
    for e in "${Environment[@]}"; do
        echo -n '   '
        # Using # instead of = because of the basedn of APACHE_LdapAuthURL
        # (and the piped through column thing below) :
        echo "$e#${!e}"
    done | column -t -s '#'
fi
# vim: ts=4 filetype=sh
