#
# standingbear.prologue.sh
#
# This file is sourced *early* by standingbear.sh, unasigned environment
# variables then get their defaults.
#

# Default to the current user :
#APACHE_RUN_USER=www-data
#APACHE_RUN_GROUP=www-data

#APACHE_Hostname=example.org
#APACHE_ListenPort=8000
#APACHE_ListenPortSSL=8001

# For hand-compiled stuff, e.g. with ./configure --prefix=/opt/httpd-2.2.23/ ...
# notably PATH would be prepended with /opt/httpd-2.2.23/bin.
prefixed_paths "$StandingBear/local/apache"
prefixed_paths "$StandingBear/local/php"

# Defaults to $SSH_CLIENT if defined! Else 127.0.0.1
#
# See httpd.local.conf about the `let_me_in' environment variable
# ( SetEnvIf .... let_me_in ).
#
# Either define it explicitly, or unset SSH_CLIENT.
#APACHE_AdminIp=127.0.0.1

# Defaults to C if not defined.
#LANG=C
#LANG=en_US.UTF-8

# A place with conf/, var/{lock,log,run,tmp,www}/.
# Defaults to $StandingBear.
#APACHE_ServerRoot="$StandingBear"

# Defaults to /usr :
#APACHE_Home=${APACHE_Home:=$APACHE_ServerRoot/local/apache}

# E.g. :
#ApacheHttpd=/usr/sbin/apache2
#ApacheHttpd=/opt/apache2/bin/httpd
#ApacheHttpd=`which apache2`
#ApacheHttpd=`which httpd`

#APACHE_Modules=/usr/lib/apache2/modules
#APACHE_Manual=/usr/share/doc/apache-2.2.23/manual
#APACHE_ErrorDocuments=/usr/share/apache2/error
#APACHE_Icons=/usr/share/apache2/icons

# Defaults to libphp5.so :
#APACHE_ModPhp5SO=libphp5.so.5.3
#APACHE_ModPhp5SO=libphp5.so.5.4

# E.g. on Gentoo :
#APACHE_ModPhp5SO=/usr/lib/php5.3/apache2/libphp5.so
#APACHE_ModPhp5SO=/usr/lib/php5.4/apache2/libphp5.so

# If not set, base search DN is made up from the domain name we belong to :
#APACHE_LdapAuthURL=${APACHE_LdapAuthURL:-"ldap://127.0.0.1:389/dc=example,dc=net?uid?sub?(objectClass=*)"}

########################################################################
## ApacheDefines bash array variable.
#
# Used in ../apachectl when launching httpd, basically these become -D xxx...
#
# From Gentoo; kind of "double usage" here with the mods-{available,enabled}/
# Debian concept, but well I like the idea.
#
# For <IfDefine ...> blocks here and there;
#
#  * LANGUAGE      : conf/mods-available/mime.conf
#  * REWRITE       : conf/mods-available/rewrite.conf
#  * AUTOINDEX     : conf/mods-available/autoindex.conf
#  * DEFAULT_VHOST : conf/sites-available/default
#  * USERDIR       : conf/mods-available/userdir.conf
#  * INFO          : conf/mods-available/info.conf
#  * STATUS        : conf/mods-available/status.conf
#  * MANUAL        : conf/conf.d/apache_manual.conf
#  * ERRORDOCS     : conf/conf.d/localized-error-pages
#  * PHP5          : conf/mods-available/php5.conf
#  * PHP5_MANUAL
#  * PROXY : conf/mods-available/proxy.conf
#  *    PROXY_FTP, PROXY_HTTP, PROXY_CONNECT,
#  *    PROXY_AJP, PROXY_SCGI,
#  *    PROXY_BALANCER
#  * LDAP : conf/mods-available/ldap.conf (mod_ldap & mod_authnz_ldap)
#
ApacheDefines=( LANGUAGE REWRITE AUTOINDEX DEFAULT_VHOST USERDIR )
ApacheDefines=( "${ApacheDefines[@]}" INFO STATUS )
ApacheDefines=( "${ApacheDefines[@]}" MANUAL ERRORDOCS )
ApacheDefines=( "${ApacheDefines[@]}" PHP5 PHP5_MANUAL )
ApacheDefines=( "${ApacheDefines[@]}" PROXY PROXY_FTP PROXY_HTTP PROXY_CONNECT PROXY_AJP )
ApacheDefines=( "${ApacheDefines[@]}" LDAP )

# vim: filetype=sh
