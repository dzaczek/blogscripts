curl -sSL https://coinbase.com/api/v1/prices/historical\?limit\=300 | tee p.txt  | gnuplot -p -e  "set terminal dumb  size $(stty -a <"/dev/`ps ax | grep $$ | grep -v grep | awk '{print $2}'`" | grep -Po '(?<=columns )\d+'),$(stty -a <"/dev/`ps ax | grep $$ | grep -v grep | awk '{print $2}'`" | grep -Po '(?<=rows )\d+') ; set ylabel 'Value \$ ' ; set title 'Coin Value' ; set xdata time ; set xdata time; set xdata time ; set timefmt '%Y-%m-%dT%H:%M' ; set datafile separator \",\" ; plot '<cat' using 1:2 title  'Bitcoin' with dots; " && cat p.txt| awk -F"," '{print $2; exit}'  #| figlet -f big -c
