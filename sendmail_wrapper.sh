#!/bin/sh

catch_all_email="`id -un`@`hostname -f`"

exec /usr/sbin/sendmail -i $catch_all_email
