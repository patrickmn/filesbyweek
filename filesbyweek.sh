#!/bin/bash
######
#
# FilesByWeek -- Count the number of files/e-mails in a folder (e.g. Linux Maildir)
#                created (or last modified) in X week of the year.
#
# Version 1.0 -- June 22nd, 2009
# http://patrickmylund.com/projects/filesbyweek/
# by Patrick Mylund - patrick@patrickmylund.com
#
####
#
# Usage:
#   ./filesbyweek [week] [dir]
#   - Example 1: ./filesbyweek 24
#   - Example 2: ./filesbyweek 24 /var/mail/name@domain.com
#
# Requirements:
#   - Linux with bash, date and find.
#
# Notice:
#   - If the script won't run, make it executable with the command:
#     chmod +x filesbyweek.sh
#   - The date command used in FilesByWeek considers Monday the first day of the week.
#     If you would like Sunday to be the first day of the week, change %W to %U within
#     the date call below.
#   - date starts counting weeks on the first Monday (or Sunday) in a new year, which
#     we work around by subtracting 1 from the week count inside the script. However, if
#     the year actually does start on a Monday, you should comment out WEEK=$((WEEK-1))
#     below.
#
####
#
# FilesByWeek is released under the MIT License:
#
# Copyright (c) 2009 Patrick Mylund
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
######

declare -i YEAR WEEK COUNT

WEEK=$1
# Comment out the following line if the year starts on a Monday
((WEEK--))
# Use current system year by default. This can be changed to e.g.: YEAR=2008
YEAR=$(date +%Y)
TGTDIR=$2
COUNT=0

\find "$TGTDIR" \
-type d \( -name "*.sent" -o -name "*.Sent" -o -name "courierimapkeywords" -o -name "courierimaphieracl" \) -prune -o \
-type f \( ! -name "subscriptions" ! -name "courierimapsubscribed" ! -name "dovecot.index.log*" ! -name "dovecot.index" ! -name "maildirfolder" ! -name "dovecot-keywords" ! -name "dovecot.index.cache" ! -name "courierimapacl" ! -name "courierimapuiddb" ! -name "dovecot-uidlist" \) \
-print |
{
    while read -r FILENAME; do
	if [[ $(\date +%Y-%W -r "$FILENAME") == "$YEAR-$WEEK" ]]; then
	    # Uncomment to show the names of matching files
	    # echo "file: $FILENAME"
	    ((COUNT++))
        fi
    done

    echo "Week $1 -- $TGTDIR: $COUNT"
}

exit 0
