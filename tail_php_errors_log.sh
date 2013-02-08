#!/bin/sh
HERE=`dirname $0`

exec tail -f "$@" $HERE/var/log/php_errors.log
