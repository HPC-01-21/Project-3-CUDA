#!/bin/gnuplot

set terminal png enhanced size 1000,600
set output 'bsl_gpu2.png'


set xlabel "Matrix Size (N)"
#set xtics [1:16]
#set ytics [1:16]
set ylabel "Time"
set title "Compare Performance of Baseline and Single Treaded GPU"
plot "medium_data" using 1:2 title "baseline" with lp,\
     "medium_data" using 1:3 title "gpu1" with lp

     


#pause mouse close
# This last line is to avoid the terminal to close 
# when you are not outputting to a file
