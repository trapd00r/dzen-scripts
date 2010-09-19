#!/bin/sh

FONT="-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252"
while true; do 
  printf "^fg(#647474)"
  date +%H:%M |perl -pe 's/(\d+):(\d+)((A|P)M)/^fg(#69996a)$1^fg():^fg(#69986b)$2^fg(#5c5c5c)$3/'
  perl /home/scp1/devel/dzen-scripts/pdzen.pl
  sleep 1
done|dzen2 -fn $FONT -x 0 -y 0 -w 1366   -ta c -u -l 1 -m h -sa c
#done |dzen2 -e 'foo' -ta r -x 0 -y 0  -w 1366  -fg '#ffffff' -bg '#0e0e0e' \
#           -fn $FONT -u -l 2

# vim: tw=99999:
