set term png size 500,500
set datafile separator ";"
set output output

set title "Trigonometric Functions Sin, Cos and Tan"

plot filename using 1:2 title "Sin" with points pt 5, \
     filename using 1:3 title "Cos" with points pt 7 