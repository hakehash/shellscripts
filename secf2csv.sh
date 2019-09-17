#!/bin/sh

if [ $# -eq 0 ]; then
  echo "usage:\tfind ./path/to/secforc | xargs -L1 `basename $0`" 1>&2
else
  ORIG=`cat $1 | grep line -n | tail -n1 | sed 's/:.*//g'`
  AREA=`cat $1 | awk 'NR=='$ORIG'+3{print $4}'`
  if [ $# -eq 2 ]; then
    LENGTH=$2
  else
    LENGTH=9480
  fi
  cat $1 | awk '{if((NR-'$ORIG')%4==1) print $2/'$LENGTH' "," $3/'$AREA'}' > ${1}.csv
fi

