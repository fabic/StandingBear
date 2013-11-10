#!/bin/sh
#
# © Fcj.2012-07
#
# TODO: pgrep, egrep ?
#

if [ $# -lt 1 ]; then
    echo "This is actually a GREP wrapper for searching stuff in here while ignoring some irrelevant directories."
    echo "Usage: $0 <any grep argument>"
    echo "       $0 <some_grep_arguments> <pattern> [dir1/ dir2/ ... dirN/]"
    echo "Examples:"
    echo "    $0 APACHE_ conf/"
    echo "    $0 -i php conf/ www/"
    exit 1
fi

grep -rHn \
	--exclude-dir ".git" \
	--exclude-dir ".svn" \
	--exclude-dir "var" \
	--exclude-dir "tmp" \
	"$@"

# vim:ft=sh
