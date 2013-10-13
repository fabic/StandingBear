#
# standingbear.prologue.sh
#
# This file is sourced *early* by standingbear.sh, unasigned environment
# variables then get their defaults.
#
# Custom environment variables may be defined here, see also
# standingbear.epilogue.sh for a chance to pass them to the
# wiped out environment Apache gets run with.
#
# Already defined when this file get sourced are :
#   * $StandingBear : Absolute path to standingbear.sh stands.
#   * $HERE : Absolute path of the executing script that sourced standingbear.sh
#   * *PATH toolkit : pathappend(), pathprepend(), pathremove(), prefixed_paths()
#

# Sample custom env. var. defined here, but actually added to
# the $Environment bash array in standingbear.epilogue.sh :
# TODO: find another name for that sample env...
#GIT_PROJECTS_ROOT="$StandingBear/git_repositories"

# Default to the current user (`id -un` & `id -gn`) :
#APACHE_RUN_USER=www-data
#APACHE_RUN_GROUP=www-data

# Typically used in vhost definition files,
# see conf/sites-available/ & conf/ports.conf 
#APACHE_Hostname=example.org
#APACHE_ListenPort=8000
#APACHE_ListenPortSSL=8001

# For hand-compiled stuff, e.g. with ./configure --prefix=/opt/httpd-2.2.23/ ...
# notably PATH would be prepended with /opt/httpd-2.2.23/bin.
#prefixed_paths "$StandingBear/local/apache"
#prefixed_paths "$StandingBear/local/php"
#prefixed_paths "/opt/php-5.3.27"

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

# Defaults to libphp5.so, may be an absolute path, else it ends up
# prepended with $APACHE_Modules.
#APACHE_ModPhp5SO=libphp5.so.5.3
#APACHE_ModPhp5SO=libphp5.so.5.4

# E.g. on Gentoo :
#APACHE_ModPhp5SO=/usr/lib/php5.3/apache2/libphp5.so
#APACHE_ModPhp5SO=/usr/lib/php5.4/apache2/libphp5.so

#
# E.g. hand-built PHP in /opt :
#APACHE_ModPhp5SO=/opt/php-5.3.27/lib/libphp5.so
#
#SlashOptPhp=/opt/php-5.3.27

#prefixed_paths $SlashOptPhp

#APACHE_ModPhp5SO=$SlashOptPhp/lib/libphp5.so

# PHP binary path (fixme: get rid of this?):
#PHPBIN=/opt/php-5.3.27/bin/php
#PHPBIN=$SlashOptPhp/bin/php
# Or, thanks to the prefixed_paths line above :
PHPBIN=`which php`

# If not set, base search DN is made up from the domain name we belong to :
#APACHE_LdapAuthURL=${APACHE_LdapAuthURL:-"ldap://127.0.0.1:389/dc=example,dc=net?uid?sub?(objectClass=*)"}

# Ruby on Rails :
APACHE_ModPassengerSo=`ls -1 /usr/lib64/ruby/gems/*/gems/passenger-*/libout/apache2/mod_passenger.so`
APACHE_ModPassenger_Root=`ls -1d /usr/lib64/ruby/gems/*/gems/passenger-*/`
APACHE_ModPassenger_Ruby=`which ruby`

# Git's git-http-backend & gitweb CGIs :
#GIT_PROJECT_ROOT=$HOME/git_repositories
#GIT_PROJECT_ROOT=$HOME/dev

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
#  * PASSENGER     : conf/mods-available/passenger.conf
#  * PHP5          : conf/mods-available/php5.conf
#  * PHP5_MANUAL
#  * SUPHP         : conf/mods-available/suphp.conf
#  * FASTCGI       : conf/mods-available/fastcgi.conf
#  * FCGID         : conf/mods-available/fcgid.conf
#  * SCGID         : conf/mods-available/scgid.conf
#  * AUTH_BASIC    : conf//mods-available/auth_basic.conf
#  * AUTH_DIGEST   : conf//mods-available/auth_digest.conf
#  * PROXY : conf/mods-available/proxy.conf
#  *    PROXY_FTP, PROXY_HTTP, PROXY_CONNECT,
#  *    PROXY_AJP, PROXY_SCGI,
#  *    PROXY_BALANCER
#  * PROXY_AUTH : Whether or not to enable forward-proxying for *All* (with authentication).
#  * LDAP : conf/mods-available/ldap.conf (mod_ldap & mod_authnz_ldap)
#  * DAV  : conf/mods-available/dav.conf
#  * GIT_HTTP_BACKEND : conf/mods-available/git-http-backend.conf
#  * GITWEB : conf/mods-available/gitweb.conf
#
# Third-party stuff :
#  * STANDINGBEAR : Enable StandingBear stuff under $_SB (e.g. /_sb/)
#  * AI_APAXY : mod_autoindex AdamWhitcroft's Apaxy theming (Git submodule)
#  * MARKDOWN
#
ApacheDefines=( LANGUAGE REWRITE AUTOINDEX AUTH_BASIC DEFAULT_VHOST )
ApacheDefines=( "${ApacheDefines[@]}" STANDINGBEAR )
ApacheDefines=( "${ApacheDefines[@]}" INFO STATUS )
ApacheDefines=( "${ApacheDefines[@]}" MANUAL ERRORDOCS )
ApacheDefines=( "${ApacheDefines[@]}" PHP5 PHP5_MANUAL )
#ApacheDefines=( "${ApacheDefines[@]}" PASSENGER )
ApacheDefines=( "${ApacheDefines[@]}" AI_APAXY )
#ApacheDefines=( "${ApacheDefines[@]}" PROXY PROXY_FTP PROXY_HTTP PROXY_CONNECT PROXY_AJP PROXY_AUTH )
#ApacheDefines=( "${ApacheDefines[@]}" USERDIR )
#ApacheDefines=( "${ApacheDefines[@]}" LDAP )
#ApacheDefines=( "${ApacheDefines[@]}" DAV )
#ApacheDefines=( "${ApacheDefines[@]}" MARKDOWN )
ApacheDefines=( "${ApacheDefines[@]}" GIT_HTTP_BACKEND )
ApacheDefines=( "${ApacheDefines[@]}" GITWEB )

# vim: filetype=sh
