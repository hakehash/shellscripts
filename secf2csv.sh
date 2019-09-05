#!/bin/sh

if [ $# -eq 0 ]; then
  echo "usage:\tfind ./path/to/secforc | xargs -L1 `basename $0`" 1>&2
else
  ORIG=`cat $1 | grep line -n | tail -n1 | sed 's/:.*//g'`
  cat $1 | awk '{if((NR-'$ORIG')%4==1) print $2 "," $3}' > ${1}.csv
fi

