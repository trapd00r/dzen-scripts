#!/bin/sh

FONT="-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252"
while true; do 
  printf "^fg(#484848)  "
  date +%H:%M
  perl /home/scp1/devel/dzen-scripts/pdzen.pl
  #perl ./pdzen.pl
  sleep 2
done |dzen2 -e 'foo' -ta r -x 0 -y 0 -w 1366  -fg '#ffffff' -bg '#0e0e0e' \
           -fn $FONT -h 15 -u -l 2 -h 17  

# vim: tw=99999:
