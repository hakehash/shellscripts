#!/bin/sh

if [ $# -eq 0 ]; then
  echo "usage:\tfind ./path/to/secforc | xargs -L1 `basename $0`" 1>&2
else
  LENGTH=6320
  while [ $# -ne 0 ]; do
    if [ -f $1 ]; then
      SECFORC=$1
    else
      LENGTH=$1
    fi
    shift
  done
  ORIG=`cat $SECFORC | grep line -n | tail -n1 | sed 's/:.*//g'`
  AREA=`cat $SECFORC | awk 'NR=='$ORIG'+3{print $4}'`
  cat $SECFORC | awk '(NR-'$ORIG')%4==1{if($1==1) print $2/'$LENGTH' "," $3/'$AREA'}' > ${SECFORC}.csv
fi

