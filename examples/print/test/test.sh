#!/bin/bash
../bin/print t1 1956 %08d
../bin/print t1 1956 %08x
../bin/print t2 0401 %f
../bin/print t2 1963 %6.2f
../bin/print t2 1989 %010.4f
../bin/print t2 3.14 %010.4e
../bin/print t2 3.14 %010.4g
../bin/print t2 1.2348 %.3f
../bin/print t2 3.1415926 %e
../bin/print t3 0401 %f
../bin/print t3 1963 %6.2f
../bin/print t3 1989 %010.4f
../bin/print t3 3.14 %010.4e
../bin/print t3 3.14 %010.4g
../bin/print t3 1.2348 %.3f
../bin/print t3 3.1415926 %e
../bin/print t4 Srinivasan %14s
../bin/print t4 Srinivasan %-14s
../bin/print t4 "Srinivasan |" %-14s
../bin/print t5 1956 %d
../bin/print t5 1956 %x
../bin/print t6 3.1415926 %e
../bin/print t7 3.1415926 %e
