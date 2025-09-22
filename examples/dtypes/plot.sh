#!/bin/bash
gnuplot -e "filename='curves.Trigonometric.csv' ; output='trig.png'" plot.gp
gnuplot -e "filename='curves.Hypotrochoid.csv' ; output='troch.png'" troch.gp
gnuplot -e "filename='curves.Hyperbolic.csv' ; output='hyper.png'" hyper.gp