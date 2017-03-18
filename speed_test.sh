#!/bin/sh

URL=http://www.google.com;
 while true; do

a=$(curl -L -w %{speed_download} -o/dev/null -s $URL);
d=$(date +%d/%m/%y%t%H:%M:%S)
echo $d";"$a>>bps.sh
 sleep 10;
 done
