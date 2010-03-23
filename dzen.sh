#!/bin/sh

FONT="-xos4-terminus-bold-r-normal--12-120-72-72-c-60-koi8-u"
while true; do 
  perl /home/scp1/devel/dzen2/pdzen.pl
  sleep 3
done |dzen2 -e 'foo' -ta r -x 0 -y 0 -w 3360  -fg '#ffffff' -bg '#1C1C1C' \
           -fn $FONT -h 15 -u -l 2 -h 17  


