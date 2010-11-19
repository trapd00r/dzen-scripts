#!/bin/sh

FONT="-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252"
while true; do 
  perl /home/scp1/devel/dzen-scripts/shiva-pdzen-right.pl
  sleep 2
done|dzen2 -fn $FONT -x 0 -y 0 -w 1680 -dock -ta l -sa l -bg '#121212'
#done|dzen2 -fn $FONT -x 0 -y 0 -w 3360   -ta r -u -l 1 -m h -sa r -dock
#done |dzen2 -e 'foo' -ta r -x 0 -y 0  -w 1366  -fg '#ffffff' -bg '#0e0e0e' \
#           -fn $FONT -u -l 2

# vim: tw=99999:
