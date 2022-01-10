#!/usr/bin/env /run/current-system/sw/bin/bash
to=$1
current=$(/run/current-system/sw/bin/fgconsole)
tmpfile=/tmp/kmonad_tty.txt

chtty() {
  /run/current-system/sw/bin/chvt $1
}

main() {
  [ -f $tmpfile ] || touch $tmpfile
  [ -s $tmpfile ] || echo -e '1\n2\n1' >> $tmpfile
  if [[ $to != $current ]]; then
    chtty $to
    echo $to >> $tmpfile
  else
    prev=$(cat $tmpfile | tail -1)
    if [ $current == $prev ]; then
       chtty $(cat $tmpfile | tail -2 | head -1)
       echo $(cat $tmpfile | tail -2 | head -1) >> $tmpfile
    else
      chtty $prev
      echo $prev >> $tmpfile
    fi
  fi
}
main
