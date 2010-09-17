#!/bin/sh

FONT="-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252"
while true; do 
  printf "^fg(#647474)"
  date +%H:%M%p|perl -pe 's/(\d+):(\d+)((A|P)M)/^fg(#69996a)$1^fg():^fg(#69986b)$2^fg(#5c5c5c)$3/'
  perl /home/scp1/devel/dzen-scripts/pdzen.pl
  #perl ./pdzen.pl
  sleep 3
done |dzen2 -e 'foo' -ta r -x 0 -y 0 -w 1366  -fg '#ffffff' -bg '#0e0e0e' \
           -fn $FONT -h 15 -u -l 2 -h 17  

# vim: tw=99999:
