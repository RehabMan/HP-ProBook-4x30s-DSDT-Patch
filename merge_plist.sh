#!/bin/bash
# set -x

# $1 is keypath to merge
# $2 is source plist
# #3 is dest plist

/usr/libexec/plistbuddy -x -c "Print \"$1\"" "$2" >/tmp/org_rehabman_temp.plist
/usr/libexec/plistbuddy -c "Merge /tmp/org_rehabman_temp.plist \"$1\"" "$3"
