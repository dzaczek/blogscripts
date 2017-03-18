set title "Analysing speed WAN\nwith date curl -L -w google.com "  textcolor linestyle 1
unset multiplot
set xdata time
#set style fill solid 1.0
set datafile separator ";"
set xlabel "Date\nTime" textcolor linestyle 1
set timefmt "%d/%m/%y %H:%M:%S"
set format x "%H:%M:%S\n%d/%m"
#set yrange [ 0 : ]
set xdata time
set autoscale  xy
set ylabel "Speeed \nbytes/s" textcolor linestyle 1
set grid

set term png background "#330000" size 1920, 960 \
 font "/usr/share/fonts/truetype/msttcorefonts/Arial.ttf,10"

set output "speedtest.png"


##colors
# Define custom display styles
set style line 1 lt 1 lc rgb "#FFCC66"
set style line 2 lt 2 lc rgb "#FF00FF" pt 6
set style line 3 lc rgb "#FFFFFF"

# Axis tic marks
set xtics textcolor linestyle 3
set key tc ls 3
set bmargin  8

set ytics  textcolor linestyle 1
set y2tics textcolor linestyle 2
#y2 mbit
set y2label "Speeed \nMegabytes/s" textcolor linestyle 1
set tics nomirror
FACTOR=0.001
set link y2 via FACTOR*y inverse y/FACTOR
#average
# number of points in moving average
n = 60
n1 = 5
# initialize the variables
do for [i=1:n] {
    eval(sprintf("back%d=0", i))
}

# build shift function (back_n = back_n-1, ..., back1=x)
shift = "("
do for [i=n:2:-1] {
    shift = sprintf("%sback%d = back%d, ", shift, i, i-1)
}
shift = shift."back1 = x)"
# uncomment the next line for a check
# print shift

# build sum function (back1 + ... + backn)
sum = "(back1"
do for [i=2:n] {
    sum = sprintf("%s+back%d", sum, i)
}
sum = sum.")"
# uncomment the next line for a check
# print sum

# define the functions like in the gnuplot demo
# use macro expansion for turning the strings into real functions
samples(x) = $0 > (n-1) ? n : ($0+1)

avg_n(x) = (shift_n(x), @sum/samples($0))
shift_n(x) = @shift
#plot
plot 'bps.sh'  using 1:2 t 'bytes/s' w points, 'bps.sh' using 1:(avg_n($2)) w l lc rgb "red" lw 2 title "avg 60 probs(10 minutes)"
