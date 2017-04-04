#!/bin/bash

#plot "<awk '{ if($1 == \"cat\") print $2,$3  }' animals.dat" u 1:2 w points title "cat", \
#     "<awk '{ if($1 == \"dog\") print $2,$3  }' animals.dat" u 1:2 w points title "dog", \
#     "<awk '{ if($1 == \"giraffe\") print $2,$3  }' animals.dat" u 1:2 w points title "giraffe"
PP="plot "
PP2="plot "
a="iotop"
n=1
totaln=`cat $a | awk '{print $13}' |  sort  | uniq |wc -l`
cat $a | awk '{print $13}' |  sort  | uniq | while IFS= read -r line; do
  lenline=${#line}
    nom=$[$nom+1]
  if (( $lenline > 0 )); then
    LL=0
    #echo ":  :  $line"
    #LL=`awk '{ if($13 == \\"$line\\") print $1,$11,$9  }' $a`
    LL=$(grep -F "$line" $a| awk '{print $1,$11,$9,$5,$7}' )
    name=`echo "$line" |  tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]'`
    filename=$name"_ios.log"
    echo "$LL" >> $filename
    # echo "$filename"

    # echo "$LL"
    #echo "$line $name"
    rr2="\"$filename\" u 1:5 w p  title \""$name"\""
    rr="\"$filename\" u 1:4 w p  title \""$name"\""
    PP=$PP$rr
    PP2=$PP2$rr2
    CH="set output \"io_os.html\""
    #echo "len line $lenline"

    if (( $nom >= $totaln )); then
      echo "Ploting"
    gnuplot -persist <<-EOFMarker
    set title "READ IO k/s"


    set xlabel "Date\nTime"
    set timefmt "%H:%M:%S"
    set format x "%H:%M:%S"
    set xdata time
    set autoscale  xy
    set xrange ["8:45:00":"9:15:00"]
    set terminal canvas solid butt size 1920,4080 fsize 14 lw 1 fontscale 1 standalone
    # set terminal canvas  rounded size 600,400 enhanced fsize 10 lw 1.6 fontscale 1 name "controls_1" jsdir "."
    set key outside;
    set key right top;
    $CH
    set multiplot layout 4, 1 title  "I/0 PLOTER "
    set title "READ I/O k/s"
    set boxwidth 0.8
    $PP
    set title "WRITE  I/O k/s"
    set boxwidth 0.8
    $PP2
    set xrange ["20:45:00":"21:15:00"]
    set title "READ I/O k/s"
    set boxwidth 0.8
    $PP
    set title "WRITE  I/O k/s"
    set boxwidth 0.8
    $PP2

       unset multiplot
EOFMarker
    echo "ssss"

      fi
    PP=$PP", "
        PP2=$PP2", "
  fi
  #gnuplot $pp
done
rm *.log
