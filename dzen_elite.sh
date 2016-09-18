#!/bin/sh
# vim:ft=zsh:

    FONT='-windows-montecarlo-medium-r-normal--11-110-72-72-c-60-microsoft-cp1252'
DZEN_OPT='-l 1 -dock -u -ta r -sa r -x 0 -y 0 -w 1600 -l 1 -bg "#121212"'

while true; do
  printf "knradio:^fg(#f79f07)"; knnp | perl -pe 's/\n//' ; printf "^fg()| "
  date '+%d %b ^fg(#ff003e)%H^fg() ^fg(#ff003e)%M^fg()' | perl -pe 's/\n/ | /g'
  printf "^fg(#f05906)%d^fg() new mail | " $(ls $HOME/mail/new | wc -l)
  printf "Bob says: ^fg(#56c7f6)"; sort -R ~/dev/bob/lyrics | head -1 | perl -pe 's/\n/ /'; printf "^fg()| "
  acpi | perl -pe 's/Battery [0-9]: //' | perl -pe 's/([0-9]+%)/^fg(#0af43a)$1^fg()/'
  sleep 60
done | dzen2 -fn $FONT $DZEN_OPTIONS

