# StandingBear : Apache2 standalone setup

Essentially based on Debian 6.0.6 Apache2 configuration layout (from
/etc/apache2/), slightly modified with a Gentoo spirit in places.

Apache is run in a wiped out environment.


## Installation

    git clone https://github.com/fabic/StandingBear.git apachesb

## Configuration :

### Configuration consists in :

* Wiped out environment setup kit (`env -i ...`), a lot of stuff get achieved by just defining the correct environment variable instead of editing the actual configuration file; see [standingbear.prologue.sh][1] & [standingbear.epilogue.sh][2] ;
* Apache defines for enabling functionalities (ex.: `-D REWRITE -D USERDIR -D DAV`) ;
* Defining vhost(s) into `conf/sites-available/` see e.g. [conf/sites-available/default][3] and symlinking the ones to enabled from there into `conf/sites-enabled/` ;
* Editing [conf/httpd.conf][4] and/or [conf/httpd.local.conf][5] ;

### Default environment without configuration would usually end up like :

With Apache httpd 2.2.x installed in `/opt/httpd-2.2.x/`.

    StandingBear=/home/fabi/dev/sb
    _SB=/_sb
    APACHE_AdminIp=127.0.0.1

    APACHE_ServerRoot=/home/fabi/dev/sb
    APACHE_ConfigFile=conf/httpd.conf

    APACHE_Home=/opt/httpd-2.2.26
    APACHE_Httpd=/opt/httpd-2.2.26/bin/httpd
    APACHE_Modules=/opt/httpd-2.2.26/modules

    APACHE_Hostname=localhost
    APACHE_ListenPort=8000
    APACHE_ListenPortSSL=8443

    APACHE_RUN_GROUP=fabi
    APACHE_RUN_USER=fabi
    APACHE_WwwRoot=/home/fabi/dev/sb/www

    APACHE_ErrorDocuments=/opt/httpd-2.2.26/error
    APACHE_Icons=/opt/httpd-2.2.26/icons
    APACHE_Manual=/opt/httpd-2.2.26/manual

    APACHE_HostDomain=nil

    APACHE_LdapAuthURL=ldap://127.0.0.1:389/?uid?sub?(objectClass=*)

    APACHE_ModPhp5SO=/opt/httpd-2.2.26/modules/libphp5.so

    LANG=en_US.UTF-8
    PATH=/home/fabi/dev/sb/bin:/opt/bin:./node_modules/.bin:/usr/local/bin:/usr/bin:/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.7.3:/usr/games/bin:/home/fabi/.bash_it/plugins/available/todo
    LD_LIBRARY_PATH=nil

    APACHE_Git_HttpBackend=/usr/libexec/git-core/git-http-backend
    APACHE_Gitweb=nil
    GIT_PROJECT_ROOT=/home/fabi/dev/sb/git_repositories
    GIT_HTTP_EXPORT_ALL=nil
    GITWEB_CONFIG=/home/fabi/dev/sb/gitweb.conf

    SVN_PROJECTS_ROOT=/home/fabi/dev/sb/svn_repositories

    APACHE_ModPassengerSo=nil
    APACHE_ModPassenger_Root=nil
    APACHE_ModPassenger_Ruby=/usr/bin/ruby

And this ends up as a `$Env` variable :

    env -i  StandingBear=/home/fabi/dev/sb _SB=/_sb APACHE_AdminIp=127.0.0.1 APACHE_ConfigFile=conf/httpd.conf APACHE_ErrorDocuments=/opt/httpd-2.2.26/error APACHE_Git_HttpBackend=/usr/libexec/git-core/git-http-backend APACHE_Gitweb=nil APACHE_Home=/opt/httpd-2.2.26 APACHE_HostDomain=nil APACHE_Hostname=localhost APACHE_Httpd=/opt/httpd-2.2.26/bin/httpd APACHE_Icons=/opt/httpd-2.2.26/icons APACHE_LdapAuthURL=ldap://127.0.0.1:389/?uid?sub?(objectClass=*) APACHE_ListenPort=8000 APACHE_ListenPortSSL=8443 APACHE_Manual=/opt/httpd-2.2.26/manual APACHE_ModPassengerSo=nil APACHE_ModPassenger_Root=nil APACHE_ModPassenger_Ruby=/usr/bin/ruby APACHE_ModPhp5SO=/opt/httpd-2.2.26/modules/libphp5.so APACHE_Modules=/opt/httpd-2.2.26/modules APACHE_RUN_GROUP=fabi APACHE_RUN_USER=fabi APACHE_ServerRoot=/home/fabi/dev/sb APACHE_WwwRoot=/home/fabi/dev/sb/www LANG=en_US.UTF-8 PATH=/home/fabi/dev/sb/bin:/opt/bin:./node_modules/.bin:/usr/local/bin:/usr/bin:/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.7.3:/usr/games/bin:/home/fabi/.bash_it/plugins/available/todo LD_LIBRARY_PATH=nil GIT_PROJECT_ROOT=/home/fabi/dev/sb/git_repositories GIT_HTTP_EXPORT_ALL=nil GITWEB_CONFIG=/home/fabi/dev/sb/gitweb.conf SVN_PROJECTS_ROOT=/home/fabi/dev/sb/svn_repositories

Which is used for invoking `httpd` in `apachectl`:

    $Env \
        $APACHE_Httpd \
        -d "$APACHE_ServerRoot" \
        -f "$APACHE_ConfigFile" \
        ${ApacheDefines[@]/#/-D } \
        "$@"

Here's a sample final command that get used to start `httpd` :

    env -i StandingBear=/home/fabi/dev/sb _SB=/_sb APACHE_AdminIp=127.0.0.1 APACHE_ConfigFile=conf/httpd.conf APACHE_ErrorDocuments=/opt/httpd-2.2.26/error APACHE_Git_HttpBackend=/usr/libexec/git-core/git-http-backend APACHE_Gitweb=nil APACHE_Home=/opt/httpd-2.2.26 APACHE_HostDomain=nil APACHE_Hostname=localhost APACHE_Httpd=/opt/httpd-2.2.26/bin/httpd APACHE_Icons=/opt/httpd-2.2.26/icons APACHE_LdapAuthURL=ldap://127.0.0.1:389/?uid?sub?(objectClass=*) APACHE_ListenPort=8000 APACHE_ListenPortSSL=8443 APACHE_Manual=/opt/httpd-2.2.26/manual APACHE_ModPassengerSo=nil APACHE_ModPassenger_Root=nil APACHE_ModPassenger_Ruby=/usr/bin/ruby APACHE_ModPhp5SO=/opt/httpd-2.2.26/modules/libphp5.so APACHE_Modules=/opt/httpd-2.2.26/modules APACHE_RUN_GROUP=fabi APACHE_RUN_USER=fabi APACHE_ServerRoot=/home/fabi/dev/sb APACHE_WwwRoot=/home/fabi/dev/sb/www LANG=en_US.UTF-8 PATH=/home/fabi/dev/sb/bin:/opt/bin:/usr/local/bin:/usr/bin:/bin GIT_PROJECT_ROOT=/home/fabi/dev/sb/git_repositories GITWEB_CONFIG=/home/fabi/dev/sb/gitweb.conf SVN_PROJECTS_ROOT=/home/fabi/dev/sb/svn_repositories \
        /opt/httpd-2.2.26/bin/httpd \
            -d /home/fabi/dev/sb \
            -f conf/httpd.conf \
            -D LANGUAGE -D REWRITE -D AUTOINDEX -D AUTH_BASIC -D DEFAULT_VHOST -D STANDINGBEAR -D INFO -D STATUS -D MANUAL -D ERRORDOCS -D DAV \
            -k start



## Usage

    # Output the environment Apache would be run with :
    sh ./standingbear.sh

    # Apache configuration test :
    ./apachectl -t
    
    # Basic virtual hosts info.
    ./apachectl -S

    # List static & shared modules.
    ./apachectl -M

    # Customization may be done in standingbear.prologue.sh and consists in
    # specifying values of environment variables that get used in Apache conf/
    # files.

    # Or from a prompt, e.g. :
    APACHE_ListenPort=8000 \
    APACHE_Modules=/usr/lib/apache2/modules \
    APACHE_ModPhp5SO=/usr/lib/apache2/modules/libphp5.so.5.4 \
        ./apachectl -t

    # Apache start, stop, restart
    ./apachectl -k start    (or ./start_www)
    ./apachectl -k stop     (or ./stop_www)

    # Note that restart sometimes seems not enough for Apache to properly
    # catch configuration changes; It happens that a real stop-start is required.
    ./apachectl -k restart

    # Stop, sleep 1 sec., Start :
    ./restart_www


## Directory layout

    bin/
        php               : A wrapper around the PHP CLI binary.

    conf/
         conf.d/
            standingbear  : /_sb/ "admin. area" is defined from herein.
         mods-available/  : Actual Apache module load & conf. statements.
         mods-enabled/    : Symlinks from ../mods-available/
         sites-available/ : default, default-ssl, www.example.org
         sites-enabled/   : Symlinks from ../sites-available/

         httpd.conf
         httpd.local.conf

    conf22/    : The Apache httpd-2.2.x conf/ dir.
    conf24/    : The Apache httpd-2.4.x conf/ dir.

    php/
        php-chunked-xhtml/  : 
        session_files/      : PHP INI session.save_path
        upload_tmp_dir/     : PHP INI upload_tmp_dir

    logs -> var/log/ symlink.

    var/
        lock/
            DAVLock/
        log/
            access_log
            error_log
            rewrite.log
            php.log         : PHP INI error_log
        run/
            httpd.pid
            httpd22.pid     : See conf22/httpd.conf
            httpd24.pid     : See conf24/httpd.conf
        tmp/                : (unused)

    # Where vhost's document root points at :
    www/
    	# Not an actual vhost, see conf/conf.d/standingbear for the Alias directives.
    	_sb/
                cgi-bin/
                htdocs/

        default/
                cgi-bin/
                dav/
                htdocs/

        www.example.org/
                cgi-bin/
                htdocs/


## Included stuff as Git submodules :

_deprecated_ **todo: remove these stuff.**

Apigen.php, Apaxy, h5ai

    git submodule status
    git submodule update --init --recursive ...



## ChangeLog

* 2013-12-20 (St-Denis) : Some review; imported as-is (mostly) the httpd-2.2 & httpd-2.4 sample configuration layouts.
* 2013-10-02 (Brussels) : Configuration review after a while...



## TODO :

* [w] README.md : Config. layout, runtime dirs, documentation.
* [ ] Move all scripts under bin/ ??
* [x] Fix Allow from env=let_me_in
* [x] Maintenance mode thing ?
* [ ] logrotate
* [~] SSL conf. ? -> needs review and testing.
* [ ] /robots.txt? (incl. search engine stuff..)
* [ ] The missing favicon.ico
* [ ] Remove symlinks from Git scm.
* [ ] local/ : Is it a good idea ? --> rename to vendor/ ?
* [ ]   » Sh script for symlinking stuff in local/apache_symlinks/ & local/php_symlinks/ ?
* [ ] ccze, AwStats...
* [x] Gitweb
* [ ] "online source browser" : find an "on-the-fly" syntax highlighter for prog./markup languages.
* [x] Have a /_sb/ for anything StandingBear specifics, basically the whole default site thing maybe.. 


### PHP

* [ ] Simple StandingBear config. check script, e.g. :
    - [ ] Correct php.ini loaded ;
    - [ ] Dumping environment variables ;
    - [ ] Dumping whole Apache config. ;
    - [ ] .. Or a simple config. browser setup ? E.g. alias /conf/ to conf/ ?
* [w] PHP 5.3, 5.4 (Apache mod_php, cgi, [ ] suexec-ed, fastcgi ?)
    -   <http://www.askapache.com/php/custom-phpini-tips-and-tricks.html>
    -   <http://php.net/manual/en/configuration.changes.php>
* [ ] PHP as cgi script samples
* [ ] mod_suPHP ?
* [w] Markdown filter <http://michelf.ca/projects/php-markdown/>
* [ ] Apigen script for e.g. generating documentation from symlinks in, say, php/sources_symlinks/, into .e.g. www/default/doc/apigen-ed/
    - [ ] <http://strapdownjs.com/> : Client-side Markdown rendering.
* [ ] Silex-based thing for rendering stuff ?
* [ ] PHPUML
* [ ] wkhtmltopdf, dompdf
* [ ] xdebug conf., e.g. xdebug.manual_url
* [ ] Find something for generating/displaying a nice searchable output of PHP's manual.


### Misc.

* [x] Tomcat AJP
* [ ] Ruby 1.8 / 1.9, mod_ruby, fastcgi-ed
* [ ] Python, incl. fastcgi, wsgi? ...
* [ ] Perl
* [ ] Node.js ?!
* [ ] Find/write ([ ] extend h5ai) a GitHub-like thing for displaying .md, .rst and such...
* [ ] Sphinx <http://sphinx-doc.org/>
* [ ] Redmine ?
* [ ] Twitter's Bootstrap-ed ?
* [ ] Blueprint-CSS ?
* [ ] WebDAV enabled app (php?) for simple drag'n'drop.
* [ ] proxy.pac file ?


### Apache modules

* [x] mod_DAV ?
* [x]   » for userdirs! e.g. ~/public_html/dav or ~/dav/ ?
* [x] auth_basic & LDAP...
* [x] Userdir conf.-- suexec cgi-bin in userdirs ?
* [ ] mod_tidy
* [ ] mod rewrite "templates" / typical stuff...
* [ ] mod_security, www-apache/modsecurity-crs (Core Rule Set)
* [ ] mod evasive ?
* [ ] www-apache/mod_musicindex <http://hacks.slashdirt.org/musicindex/>
* [ ] mod_fcgid vs mod_fastcgi
* [x] mod_dav_svn
* [ ] www-apache/mod_bw (http://www.ivn.cl/apache/)
* [ ] www-apache/mod_loadavg 
* [ ] www-apache/mod_proxy_html <http://apache.webthing.com/mod_proxy_html/>
* [ ] <http://anyterm.org/>

[1]: standingbear.prologue.sh
[2]: standingbear.epilogue.sh
[3]: conf/sites-available/default
[4]: conf/httpd.conf
[5]: conf/httpd.local.conf
