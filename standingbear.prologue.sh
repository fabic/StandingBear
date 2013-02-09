#
# standingbear.prologue.sh
#
# This file is sourced *early* by standingbear.sh, unasigned environment
# variables then get their defaults.
#

prefixed_paths "$StandingBear/local/apache"
prefixed_paths "$StandingBear/local/php"

# Defaults to $SSH_CLIENT if defined!
# See httpd.local.conf about SetEnvIf .. let_me_in
#APACHE_AdminIp=127.0.0.1

# Defaults to C if not defined.
#LANG=C
#LANG=en_US.UTF-8

# A place with conf/, var/{lock,log,run,tmp,www}/. Defaults to $StandingBear.
#APACHE_ServerRoot="$StandingBear"

#export APACHE_RUN_USER=www-data
#export APACHE_RUN_GROUP=www-data

#APACHE_Hostname=example.org
#APACHE_ListenPort=8000
#APACHE_ListenPortSSL=8001

# Defaults to /usr :
#APACHE_Home=${APACHE_Home:=$APACHE_ServerRoot/local/apache}

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

##
# Used in ../apachectl when launching httpd, basically these become -D xxx...
#
# (from Gentoo, kind of "double usage" here with the mods-{available,enabled} Debian concept, but well...)
#
# For <IfDefine ...> here and there.
#
#  *  MANUAL
#  *  ERRORDOCS
#  *  INFO
#  *  STATUS
#  *  LANGUAGE
#  *  REWRITE
#  *  PHP5
#  *  PHP5_MANUAL
#
#  *  DEFAULT_VHOST
#  *  USERDIR
#  *  AUTOINDEX
#
#  * PROXY
#  * PROXY_FTP,
#  * PROXY_HTTP, PROXY_CONNECT,
#  * PROXY_AJP,
#  * PROXY_SCGI,
#  * PROXY_BALANCER
#
#  * LDAP
#
ApacheDefines=( MANUAL ERRORDOCS INFO STATUS LANGUAGE REWRITE PHP5 PHP5_MANUAL DEFAULT_VHOST USERDIR AUTOINDEX )
ApacheDefines=( "${ApacheDefines[@]}" PROXY PROXY_FTP PROXY_HTTP PROXY_CONNECT PROXY_AJP )
ApacheDefines=( "${ApacheDefines[@]}" LDAP )

# If not set, base search DN is made up from the domain name we belong to :
#APACHE_LdapAuthURL=${APACHE_LdapAuthURL:-"ldap://127.0.0.1:389/dc=example,dc=net?uid?sub?(objectClass=*)"}

# vim: filetype=sh
