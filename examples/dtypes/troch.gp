set term png size 500,500
set datafile separator ";"
set output output

set title "Hypotrochoid"

plot filename using 2:3 with points pt 5