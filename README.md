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
         mods-available/ : Actual Apache module load & conf. statements.
         mods-enabled/   (symlinks from ../mods-available/)
         sites-available/ : default, default-ssl, www.example.org
         sites-enabled/  : Symlinks from ../sites-available/

         httpd.conf
         httpd.local.conf

    php/
        php.ini

    var/
        lock/
        log/
        run/
        tmp/ (unused)

    # Where vhost's document root points at :
        www/
        www/default/
        www/default/cgi-bin/
        www/www.example.org/
        www/www.example.org/cgi-bin/

    www -> var/www/default/   (symlink)

## Included stuff as Git submodules :

Apigen.php, Apaxy, h5ai

    git submodule status
    git submodule update --init --recursive



## TODO:

* [x] Fix Allow from env=let_me_in
* [x] auth_basic & LDAP...
* [x] Userdir conf.-- suexec cgi-bin in userdirs ?
* [ ] Maintenance mode thing ?
* [ ] logrotate
* [ ] README.md : Config. layout, runtime dirs, documentation.

* [ ] Remove symlinks from Git scm.
* [ ] local/ : Is it a good idea ?
* [ ]   » Sh script for symlinking stuff in local/apache_symlinks/ & local/php_symlinks/ ?
* [ ] ccze, AwStats...

* [w] PHP 5.3, 5.4 (Apache mod_php, cgi, [ ] suexec-ed, fastcgi ?)
    -   http://www.askapache.com/php/custom-phpini-tips-and-tricks.html
    -   http://php.net/manual/en/configuration.changes.php
* [ ] PHP as cgi script samples

* [x] Tomcat AJP
* [ ] mod_DAV ?
* [ ] Gitweb ?
* [ ] Ruby
* [ ] Python, incl. fastcgi...
* [ ] Perl
* [ ] Node.js ?!
* [ ] wkhtmltopdf, dompdf
* [ ] Find/write ([ ] extend h5ai) a GitHub-like thing for displaying .md, .rst and such...
* [ ] mod rewrite "templates" / typical stuff...
* [ ] mod evasive ?
