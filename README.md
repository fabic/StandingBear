# StandingBear : Apache2 standalone setup

Essentially based on Debian 6.0.6 Apache2 configuration layout (from
/etc/apache2/), slightly modified with a Gentoo spirit in places.

Apache is run in a wiped out environment.

## Installation

    git clone git://github.com/Oeil-de-nuit/StandingBear.git

## Configuration :

Configuration consists in :

* Wiped out environment setup, see [standingbear.prologue.sh][1] & [standingbear.epilogue.sh][2] ;
* Apache defines for enabling functionalities ;
* Defining vhost(s), see e.g. [conf/sites-available/default][3] ;
* [conf/httpd.conf][4] & [conf/httpd.local.conf][5] ;

Default environment without configuration would usually end up like :

	StandingBear           /home/fabi/dev/standingbear
	_SB                    /_sb
	APACHE_AdminIp         127.0.0.1
	APACHE_ConfigFile      conf/httpd.conf
	APACHE_ErrorDocuments  /usr/share/apache2/error
	APACHE_Home            /usr
	APACHE_HostDomain      me
	APACHE_Hostname        randombinarythoughts.com
	APACHE_Httpd           /usr/sbin/apache2
	APACHE_Icons           /usr/share/apache2/icons
	APACHE_LdapAuthURL     ldap://127.0.0.1:389/dc=randombinarythoughts,dc=com?uid?sub?(objectClass=*)
	APACHE_ListenPort      8000
	APACHE_ListenPortSSL   8001
	APACHE_Manual          /usr/share/doc/apache-2.2.24/manual
	APACHE_ModPhp5SO       /usr/lib/apache2/modules/libphp5.so
	APACHE_Modules         /usr/lib/apache2/modules
	APACHE_RUN_GROUP       fabi
	APACHE_RUN_USER        fabi
	APACHE_ServerRoot      /home/fabi/dev/standingbear
	LANG                   en_US.UTF-8
	PATH                   /home/fabi/dev/standingbear/bin:/home/fabi/bin:/opt/bin:/usr/local/bin:/usr/bin:/bin
	LD_LIBRARY_PATH        nil


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
    ./apachectl -k restart  (or ./restart_www)

## Directory layout

    bin/

    conf/
         conf.d/
         mods-available/  : Actual Apache module load & conf. statements.
         mods-enabled/    : Symlinks from ../mods-available/
         sites-available/ : default, default-ssl, www.example.org
         sites-enabled/   : Symlinks from ../sites-available/

         httpd.conf
         httpd.local.conf

    php/
        php.ini

    var/
        lock/
            DAVLock/
        log/
        run/
        tmp/ (unused)

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

Apigen.php, Apaxy, h5ai

    git submodule status
    git submodule update --init --recursive ...



## TODO:

* [w] README.md : Config. layout, runtime dirs, documentation.
* [ ] Move all scripts under bin/ ??
* [x] Fix Allow from env=let_me_in
* [x] Maintenance mode thing ?
* [ ] logrotate
* [ ] SSL conf. ?
* [ ] /robots.txt? (incl. search engine stuff..)
* [ ] The missing favicon.ico
* [ ] Remove symlinks from Git scm.
* [ ] local/ : Is it a good idea ? --> rename to vendor/ ?
* [ ]   » Sh script for symlinking stuff in local/apache_symlinks/ & local/php_symlinks/ ?
* [ ] ccze, AwStats...
* [ ] Gitweb ?
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
* [ ] mod_dav_svn
* [ ] www-apache/mod_bw (http://www.ivn.cl/apache/)
* [ ] www-apache/mod_loadavg 
* [ ] www-apache/mod_proxy_html <http://apache.webthing.com/mod_proxy_html/>
* [ ] <http://anyterm.org/>

[1]: standingbear.prologue.sh
[2]: standingbear.epilogue.sh
[3]: conf/sites-available/default
[4]: conf/httpd.conf
[5]: conf/httpd.local.conf
