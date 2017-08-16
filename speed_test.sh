#!/bin/sh

#* * * * * /bin/sh /home/root/speed_test.sh
#* * * * * (sleep 10; /bin/sh /home/root/speed_test.sh)
#* * * * * (sleep 20; /bin/sh /home/root/speed_test.sh)
#* * * * * (sleep 50; /bin/sh /home/root/speed_test.sh)
#* * * * * (sleep 30; /bin/sh /home/root/speed_test.sh)
#* * * * * (sleep 40; /bin/sh /home/root/speed_test.sh)

URL=http://www.google.com;
IPa="8.8.8.8"
 #while true; do

a=$(curl -L -w %{speed_download} -o/dev/null -s $URL);
d=$(date +%d/%m/%y%t%H:%M:%S)
c=$(ping  -c4  -q $IPa | awk -F '/' 'END {print $5}' )
echo $d";"$a";"$c >>/home/root/bps.dat
 #sleep 10;
 #done
~                                                                                                                                                      
~
