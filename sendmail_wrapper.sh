#!/bin/sh
#
# Simply forward emails sent through Sendmail to a "catch-all" email address.
#
# See conf/mods-enabled/php5.conf : php_admin_value sendmail_path ...
#

catch_all_email="`id -un`@`hostname -f`"

exec /usr/sbin/sendmail -i $catch_all_email
