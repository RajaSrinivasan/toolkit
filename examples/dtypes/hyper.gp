set term png size 500,500
set datafile separator ";"
set output output

set title "Hyperbolic Functions Sinx, Cosh and Tanh"

plot filename using 1:2 title "Sinh" with points pt 5, \
     filename using 1:3 title "Cosh" with points pt 7