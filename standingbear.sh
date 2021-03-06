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
# todo/fixme: don't use locate.

# For scripts to have their location at hands-reach, realpath
# so that scripts can be symlinked :
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

# URL space where to make available our stuff :
_SB=${_SB:-/_sb}

LANG=${LANG:-C}

# See conf/httpd.local.conf about Apache env. var. `let_me_in` :
APACHE_AdminIp=${APACHE_AdminIp:-${SSH_CLIENT%% *}}
APACHE_AdminIp=${APACHE_AdminIp:-127.0.0.1}

APACHE_ServerRoot=${APACHE_ServerRoot:-$StandingBear}
APACHE_ConfigFile=${APACHE_ConfigFile:-conf/httpd.conf}

# www/ : The place where the misc. virtual host web stuff reside.
APACHE_WwwRoot=${APACHE_WwwRoot:-"$APACHE_ServerRoot/www"}

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
APACHE_RUN_GROUP=${APACHE_RUN_GROUP:-`id -ng`}

# Note: May evaluate to ""
APACHE_HostDomain=${APACHE_HostDomain:-`hostname -d`}

APACHE_Hostname=${APACHE_Hostname:-`hostname -f`}
APACHE_ListenPort=${APACHE_ListenPort:-8000}
APACHE_ListenPortSSL=${APACHE_ListenPortSSL:-8001}

# See conf/mods-available/php5.conf
APACHE_ModPhp5SO=${APACHE_ModPhp5SO:-$APACHE_Modules/libphp5.so}
# If it's not an absolute path, prepend Apache modules path :
if [ "x${APACHE_ModPhp5SO##/*}" != "x" ]; then
    APACHE_ModPhp5SO="$APACHE_Modules/$APACHE_ModPhp5SO"
fi

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
PHPINI=${PHPINI:-}
#PHPINI=${PHPINI:-$StandingBear/php/php.ini}

# Git's git-http-backend
GIT_PROJECT_ROOT=${GIT_PROJECT_ROOT:-$StandingBear/git_repositories}
GITWEB_CONFIG=${GITWEB_CONFIG:-$StandingBear/gitweb.conf}
APACHE_Git_HttpBackend=`git --exec-path`/git-http-backend
APACHE_Gitweb=$(dirname `locate gitweb.cgi | tail -n1`)

# Subversion (SVN) root dir. of repositories (for SVNParentPath directive) :
# @link http://svnbook.red-bean.com/en/1.7/svn.serverconfig.httpd.html
# @see conf/mods-available/dav_svn.conf
SVN_PROJECTS_ROOT=${SVN_PROJECTS_ROOT:-$StandingBear/svn_repositories}

# Ruby on Rails & Apache « passenger » module :
APACHE_ModPassengerSo=`locate libout/apache2/mod_passenger.so | tail -n1`
APACHE_ModPassenger_Root=${APACHE_ModPassengerSo%libout/apache2/mod_passenger.so}
APACHE_ModPassenger_Ruby=`which ruby`

# Used in monitor_access_log.sh
CCZEBIN=`which ccze`

# Array of environment variable names that are to be imported into the
# "empty env." (See 'env -i' invocation further below) :

# $Environment may have been already set from standingbear.prologue.sh, ...
declare -a Environment

# ... and we're about to prepend stuff to it :
Environment=( StandingBear _SB "${!APACHE@}" LANG PATH LD_LIBRARY_PATH GIT_PROJECT_ROOT GIT_HTTP_EXPORT_ALL GITWEB_CONFIG SVN_PROJECTS_ROOT "${Environment[@]}" )

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
    declare $e="${!e:=nil}"
    Env="$Env $e=${!e}"
done

# fixme: Yes, no, why actually ?
export ${Environment[@]}

#
# Display environment if we're being run :
# todo: have it be a sb_display_env()?
#
if [ `basename "$0"` == "${BASH_SOURCE[0]}" ]; then
    echo "--- \$HERE=$HERE"
    echo "--- Environment: ---"
    for e in "${Environment[@]}"; do
        echo -n '   '
        # Using # instead of = because of the basedn of APACHE_LdapAuthURL
        # (and the piped through column thing below) :
        echo "$e#${!e}"
    done | column -t -s '#'
    echo "--- \$Env: ---"
    echo "$Env"
    echo "--- Apache Defines: ---"
    echo ${ApacheDefines[@]}
fi
# vim: ts=4 filetype=sh
