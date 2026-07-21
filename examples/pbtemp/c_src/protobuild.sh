#!/bin/bash
$NANOPBDIR/generator/protoc --nanopb_out=. simple.proto
/usr/bin/gcc -c -I $NANOPBDIR $NANOPBDIR/pb_common.c
/usr/bin/gcc -c -I $NANOPBDIR $NANOPBDIR/pb_encode.c
/usr/bin/gcc -c -I $NANOPBDIR $NANOPBDIR/pb_decode.c
/usr/bin/gcc -c -I $NANOPBDIR simple.pb.c
/usr/bin/gcc -c -I $NANOPBDIR getset.c
/usr/bin/ar rv libpbtemp.a *.o
