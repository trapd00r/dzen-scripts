#!/bin/sh

FONT="-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252"
while true; do 
  printf "^fg(#647474)"
  perl /home/scp1/devel/dzen-scripts/shiva-pdzen-left.pl
  sleep 5
done|dzen2 -fn $FONT -l 1 -dock -u -ta r -sa r -x 0 -y 0 -w 1680 -l 1 -bg '#121212'
#done|dzen2 -fn $FONT -x 0 -y 0 -w 1680 -l 1 -dock 
#done|dzen2 -fn $FONT -x 0 -y 0 -w 3360   -ta r -u -l 1 -m h -sa r -dock
#done |dzen2 -e 'foo' -ta r -x 0 -y 0  -w 1366  -fg '#ffffff' -bg '#0e0e0e' \
#           -fn $FONT -u -l 2

# vim: tw=99999:
