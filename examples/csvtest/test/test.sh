#!/bin/bash
../bin/csvtest T1 raw_bp.csv 
sed -n "5,2000p" 0100.csv > 0100_a.csv
../bin/csvtest T2 0100_a.csv | sed -n "10,1000p" > bptest.csv
gnuplot bptest.gp