# StandingBear : Apache2 standalone setup

Essentially based on Debian 6.0.6 Apache2 configuration layout (from
/etc/apache2/), slightly modified with a Gentoo spirit in places.

Apache is run in a wiped out environment.

## Installation

    git clone git://github.com/Oeil-de-nuit/StandingBear.git

## Usage

    # Output the environment Apache would be run with :
    sh ./standingbear.sh

    # Apache configuration test :
    ./apachectl -t
    ./apachectl -S
    ./apachectl -M

    # Customization may be done in standingbear.prologue.sh and consists in
    # specifying values of environment variables that get used in Apache conf/
    # files.

    # Or from a prompt, e.g. :
    APACHE_ListenPort=1234 \
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
* [ ] Maintenance mode thing ?
* [ ] logrotate
* [ ] SSL conf. ?
* [ ] /robots.txt? (incl. search engine stuff..)
* [ ] The missing favicon.ico
* [ ] Remove symlinks from Git scm.
* [ ] local/ : Is it a good idea ?
* [ ]   » Sh script for symlinking stuff in local/apache_symlinks/ & local/php_symlinks/ ?
* [ ] ccze, AwStats...
* [ ] Gitweb ?

### PHP

* [w] PHP 5.3, 5.4 (Apache mod_php, cgi, [ ] suexec-ed, fastcgi ?)
    -   <http://www.askapache.com/php/custom-phpini-tips-and-tricks.html>
    -   <http://php.net/manual/en/configuration.changes.php>
* [ ] PHP as cgi script samples
* [ ] mod_suPHP ?
* [ ] Apigen script for e.g. generating documentation from symlinks in, say, php/sources_symlinks/, into .e.g. www/default/doc/apigen-ed/
* [ ] wkhtmltopdf, dompdf

### Misc.
* [x] Tomcat AJP
* [ ] Ruby
* [ ] Python, incl. fastcgi, wsgi? ...
* [ ] Perl
* [ ] Node.js ?!
* [ ] Find/write ([ ] extend h5ai) a GitHub-like thing for displaying .md, .rst and such...

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
