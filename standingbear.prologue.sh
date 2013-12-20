#
# standingbear.prologue.sh
#
# This is the main configuration file. Setup consists of altering environment
# variables here that would otherwise get their default values.
#
# It is sourced *early* by standingbear.sh, unasigned environment variables
# then get their defaults.
#
# Custom environment variables may be defined here with the intent (or not) of
# having these passed to Apache.
#
# Optionally a second configuration file, standingbear.epilogue.sh, may be used
# for altering environment variables *after* these have got their defaults from
# standingbear.sh
#
# Already defined when this file get sourced are :
#   * $StandingBear : Absolute path to standingbear.sh stands.
#   * $HERE : Absolute path of the executing script that sourced standingbear.sh
#   * $PATH toolkit : pathappend(), pathprepend(), pathremove(), prefixed_paths()
#
# Of special interest here for getting things running are :
#   * The bash array $Environment : A list of environment variable names that shall
#     be passed to Apache ;
#   * The Apache_* environment variables : These get passed automatically to Apache,
#     by being added to $Environment ;
#   * The bash array $ApacheDefines : A list of Apache defines (ex. -D MyDefine),
#     for <IfDefine MyDefine>...</IfDefine> construct.

## At the bare minimum, and first step, is to A) specify (where is) the Apache
## binary with APACHE_Httpd :
#APACHE_Httpd=httpd
#APACHE_Httpd=apache2
#APACHE_Httpd=`which apache2`
#APACHE_Httpd=`which httpd`
#APACHE_Httpd=/usr/sbin/apache2
#APACHE_Httpd=/opt/apache2/bin/httpd

## Additionnally there some guessing magic in standingbear.sh that use APACHE_Home
## for guessing it all (id defaults to /usr):
#APACHE_Home=/opt/httpd
#APACHE_Home=/opt/httpd-2.2.23
#APACHE_Home=${APACHE_Home:=$APACHE_ServerRoot/local/httpd}

## And B) whence are the Apache modules :
#APACHE_Modules=/usr/lib/apache2/modules

## C) A few more but less important ones are :
#APACHE_Manual=/usr/share/doc/apache-2.2.23/manual
#APACHE_ErrorDocuments=/usr/share/apache2/error
#APACHE_Icons=/usr/share/apache2/icons


## Apache personality (User, Group) ; default to the current user (`id -un` & `id -gn`),
## but would better being set explicitly, specifically if intent is to be launched
## as root (ex. for using ports under 1024) :
#APACHE_RUN_USER=www-data
#APACHE_RUN_GROUP=www-data
#APACHE_RUN_USER=fabi
#APACHE_RUN_GROUP=apache

## Apache will refuse to be run as root :
if [ `id -u` == 0 ]; then
	echo "INFO: WE'RE BEING INVOKED AS ROOT."
	[ -z $APACHE_RUN_USER ] && echo "APACHE_RUN_USER is not set! Exiting..." && exit 1
	[ -z $APACHE_RUN_GROUP ] && echo "APACHE_RUN_GROUP is not set! Exiting..." && exit 2
fi

## Typically used in vhost definition files, see conf/sites-available/ & conf/ports.conf
#APACHE_Hostname=example.org
#APACHE_ListenPort=80
#APACHE_ListenPortSSL=443
APACHE_ListenPort=8000
APACHE_ListenPortSSL=8443


## Sample custom env. var. defined here :
#My_Custom_Var="AValueThatShallNotContainSpaces"
## That env. var. may eventually be passed to Apache by adding it to the Environment
## bash array :
#Environment=( "${Environment[@]}" My_Custom_Var )


## The few path manipulation bash functions may come handy, ex. for handling
## hand-compiled stuff in a "seamless / somewhat more conventionnal" manner.
##
## Ex. with Apache httpd having been installed under /opt/, here among others
## $PATH would be prepended with /opt/httpd/bin.
#prefixed_paths "/opt/httpd"
#prefixed_paths "$StandingBear/local/apache"
#prefixed_paths "$StandingBear/local/php"


# Defaults to $SSH_CLIENT if defined! Else 127.0.0.1
#
# See httpd.local.conf about the `let_me_in' environment variable
# ( SetEnvIf .... let_me_in ).
#
# Either define it explicitly, or unset SSH_CLIENT.
#APACHE_AdminIp=127.0.0.1


## Would default to $LANG that is currently defined, else defaults to "C" ;
## use `locale -a` for listing your available locales.
#LANG=C
#LANG=en
#LANG=en_US.UTF-8
#LANG=en_US.utf8
#LANG=en_US.iso88591

## A place with conf/, var/{lock,log,run,tmp,www}/.
## Defaults to $StandingBear and shall remain to that value.
#APACHE_ServerRoot="$StandingBear"


#########
## PHP ##
#########

## Defaults to libphp5.so, may be an absolute path, else it ends up
## prepended with $APACHE_Modules.
#APACHE_ModPhp5SO=libphp5.so.5.3
#APACHE_ModPhp5SO=libphp5.so.5.4

## E.g. on Gentoo :
#APACHE_ModPhp5SO=/usr/lib/php5.3/apache2/libphp5.so
#APACHE_ModPhp5SO=/usr/lib/php5.4/apache2/libphp5.so
#APACHE_ModPhp5SO=/usr/lib/php5.5/apache2/libphp5.so

##
## Or with a hand-built PHP in /opt :
##

# A custom env. var. SlashOptPhp that won't get passed to Apache may be used :
#SlashOptPhp=/opt/php-5.3.23
#SlashOptPhp=/opt/php-5.3.27

#prefixed_paths $SlashOptPhp

# See conf/mods-available/php5.conf
#APACHE_ModPhp5SO=$SlashOptPhp/lib/libphp5.so

# PHP binary path (fixme: get rid of this?):
#PHPBIN=$SlashOptPhp/bin/php
# Or, thanks to the prefixed_paths line above :
PHPBIN=`which php`

# If not set, base search DN is made up from the domain name we belong to :
#APACHE_LdapAuthURL=${APACHE_LdapAuthURL:-"ldap://127.0.0.1:389/dc=example,dc=net?uid?sub?(objectClass=*)"}

# Ruby on Rails & Apache "passenger" module :
#APACHE_ModPassengerSo=`ls -1 /usr/lib64/ruby/gems/*/gems/passenger-*/libout/apache2/mod_passenger.so | tail -n1`
#APACHE_ModPassenger_Root=`ls -1d /usr/lib64/ruby/gems/*/gems/passenger-*/ | tail -n1`
#APACHE_ModPassenger_Ruby=`which ruby`

# Git's git-http-backend & gitweb CGIs :
#GIT_PROJECT_ROOT=$HOME/git_repositories
#GIT_PROJECT_ROOT=$HOME/dev

# SVN repositories root, served under /svn, defaults to svn_repositories/ ;
# @see conf/mods-available/dav_svn.conf
# Ex.:
#    $ svnadmin create svn_repositories/testrepo
#    $ svn info http://localhost:8000/svn/testrepo
#
#SVN_PROJECTS_ROOT=$HOME/dev/svn_repositories

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
#  * SSL_DEFAULT_VHOST : conf/sites-available/default-ssl
#  * SSL           : conf/mods-available/ssl.conf
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
#  * SVN        : conf/mods-available/dav_svn.conf
#  * SVN_AUTHZ  : conf/mods-available/dav_svn.conf
#
# Third-party stuff :
#  * STANDINGBEAR : Enable StandingBear stuff under $_SB (e.g. /_sb/)
#  * AI_APAXY : mod_autoindex AdamWhitcroft's Apaxy theming (Git submodule)
#  * MARKDOWN
#
ApacheDefines=( LANGUAGE REWRITE AUTOINDEX AUTH_BASIC DEFAULT_VHOST )
#ApacheDefines=( "${ApacheDefines[@]}" SSL SSL_DEFAULT_VHOST )
ApacheDefines=( "${ApacheDefines[@]}" STANDINGBEAR )
ApacheDefines=( "${ApacheDefines[@]}" INFO STATUS )
ApacheDefines=( "${ApacheDefines[@]}" MANUAL ERRORDOCS )
#ApacheDefines=( "${ApacheDefines[@]}" PHP5 PHP5_MANUAL )
#ApacheDefines=( "${ApacheDefines[@]}" PASSENGER )
#ApacheDefines=( "${ApacheDefines[@]}" AI_APAXY )
#ApacheDefines=( "${ApacheDefines[@]}" PROXY PROXY_FTP PROXY_HTTP PROXY_CONNECT PROXY_AJP PROXY_AUTH )
#ApacheDefines=( "${ApacheDefines[@]}" USERDIR )
#ApacheDefines=( "${ApacheDefines[@]}" LDAP )
#ApacheDefines=( "${ApacheDefines[@]}" DAV )
#ApacheDefines=( "${ApacheDefines[@]}" MARKDOWN )
#ApacheDefines=( "${ApacheDefines[@]}" GIT_HTTP_BACKEND )
#ApacheDefines=( "${ApacheDefines[@]}" GITWEB )
#ApacheDefines=( "${ApacheDefines[@]}" DAV SVN )

#######################################################################
### Custom "to-be-passed" environment may be done from within here, ###
### or in standingbear.epilogue.sh                                  ###
#######################################################################

## Sybase ASE 15.x :
#SYBASE=${SYBASE:-/opt/sybase}
#SYBASE_OCS=${SYBASE_OCS:-OCS-15_0}
#DSQUERY=${DSQUERY:-}

## Or we may simply source the Sybase provided file:
#source /opt/sybase/SYBASE.sh

## From time to time I have to set it for dl to resolve Sybase libsyb*64.so, e.g. :
##    « Cannot load /opt/php-5.3.23/lib/libphp5.so into server:
##        libsybunic64.so: cannot open shared object file: No such file or directory »
## Specifically this may be needed when Apache is invoked as root (an alternative
## would be to add this to /etc/ld.so.conf ).
#pathprepend "$SYBASE/$SYBASE_OCS/lib" LD_LIBRARY_PATH

#Environment=( "${Environment[@]}" SYBASE SYBASE_OCS DSQUERY )


##
## For the sample virtual host (conf/sites-available/dev) :
##     * Enabled by an Apache define: VHOST_DEV
##     * ...
##
#VHOST_Dev_Root=/home/fabi/dev/www
# Take care with $HOME if you intend to invoke httpd as root!
VHOST_Dev_Root="$HOME/dev/www"
if [ -d "$VHOST_Dev_Root" ]; then
	ApacheDefines=( "${ApacheDefines[@]}" VHOST_DEV )
	VHOST_Dev_ServerName=${APACHE_Hostname}
	let VHOST_Dev_ListenPort=$APACHE_ListenPort+1
	Environment=( "${Environment[@]}" VHOST_Dev_Root VHOST_Dev_ListenPort VHOST_Dev_ServerName )
fi

# vim: filetype=sh
