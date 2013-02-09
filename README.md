# StandingBear : Apache2 standalone setup

Essentially based on Debian 6.0.6 Apache2 configuration layout (from
/etc/apache2/), slightly modified with a Gentoo spirit in places.

# Installation

    git clone git://github.com/Oeil-de-nuit/StandingBear.git

## Eventually...
    git submodule status
    git submodule update --init --recursive

# TODO:

* [x] Fix Allow from env=let_me_in
* [x] auth_basic & LDAP...
* [x] Userdir conf.
* [ ] Maintenance mode thing ?
* [ ] logrotate

* [ ] Remove symlinks from Git scm.
* [ ] local/ : Is it a good idea ?
* [ ]   » Sh script for symlinking stuff in local/apache_symlinks/ & local/php_symlinks/ ?

* [w] PHP 5.3, 5.4 (Apache mod_php, cgi, suexec-ed, fastcgi ?)
        http://www.askapache.com/php/custom-phpini-tips-and-tricks.html
        http://php.net/manual/en/configuration.changes.php

* [x] Tomcat AJP
* [ ] mod_DAV ?
* [ ] Gitweb ?
* [ ] Perl
* [ ] Ruby
* [ ] Python, incl. fastcgi...
* [ ] Node.js ?!
* [ ] wkhtmltopdf, dompdf
* [ ] Find/write ([ ] extend h5ai) a GitHub-like thing for displaying .md, .rst and such...
* [ ] mod rewrite "templates" / typical stuff...
* [ ] mod evasive ?
