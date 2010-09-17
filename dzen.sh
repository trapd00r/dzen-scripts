#!/bin/sh

FONT="-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252"
while true; do 
  perl /home/scp1/devel/dzen-scripts/pdzen.pl
  uptime|awk {'print "^fg(#f80412)"$10"^fg(#f83c04)"$11"^fg(#f86b04)"$12'}|perl -pe 's/,/ ^fg()| /g'
  #perl ./pdzen.pl
  sleep 3
done |dzen2 -e 'foo' -ta r -x 0 -y 0 -w 1366  -fg '#ffffff' -bg '#030303' \
           -fn $FONT -h 15 -u -l 2 -h 17  

# vim: tw=99999:
