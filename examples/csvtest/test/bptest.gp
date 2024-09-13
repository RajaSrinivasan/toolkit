set term png size 1000,500
set output 'bptest.png'

set title "Blood pressure and ECG waveforms" 
plot 'bptest.csv' using 1:2 with lines title "ECG" 

set output 'bptest2.png'
plot 'bptest.csv' using 1:3 with lines title "BP" 