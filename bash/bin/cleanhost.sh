#!/bin/bash
set -o nounset
set -o errexit

###############################################################################
##### This script will generate an IPv4-only hosts file that blocks domains
##### responsible for advertisements, analytics, and malicious activities
#####
##### Modified from: https://github.com/fr0stycl34r/update-hosts
###############################################################################


## We must be root in order to modify the contents of /etc
rootcheck() {
  if [[ $UID -ne 0 ]]; then
    echo "Please run this script as root"
    exit 1
  fi
}
rootcheck


## Backup the current hosts file
mv /etc/hosts /etc/hosts.bak


## Create a temporary file to dump the various lists into
temphosts=$(mktemp)


## Download various pre-made lists into our temp file
wget -nv -O - http://someonewhocares.org/hosts/hosts >> $temphosts
wget -nv -O - http://winhelp2002.mvps.org/hosts.txt >> $temphosts
wget -nv -O - http://www.malwaredomainlist.com/hostslist/hosts.txt >> $temphosts
wget -nv -O - http://adblock.gjtech.net/?format=hostfile >> $temphosts
wget -nv -O - http://hosts-file.net/ad_servers.asp >> $temphosts
wget -nv -O - "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" >> $temphosts


## Cleanup the list; remove commented lines, remove duplicates, etc
sed -e 's/\r//' -e '/^127.0.0.1/!d' -e '/localhost/d' -e 's/0.0.0.0/127.0.0.1/' -e 's/ \+/\t/' -e 's/#.*$//' -e 's/[ \t]*$//' < $temphosts | sort -u > /etc/hosts


## Append some necessary stuff to the beginning of the file
echo "# Last updated on $(date)

127.0.0.1 $HOSTNAME" | cat - /etc/hosts >> temp && mv temp /etc/hosts


## A bit of cleanup
rm $temphosts