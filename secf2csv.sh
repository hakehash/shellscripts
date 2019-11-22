#!/bin/sh

if [ $# -eq 0 ]; then
  echo "usage:\tfind ./path/to/secforc | xargs -L1 `basename $0`" 1>&2
else
  while [ $# -ne 0 ]; do
    if [ -f $1 ]; then
      SECFORC=$1
    else
      LENGTH=$1
    fi
    shift
  done

  getxmin(){
    cat $DYNFILE |\
      awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
      grep -v \\$ | sort -n -k 2 | head -n1 | awk '{printf("%d",$2)}'
  }
  getxmax(){
    cat $DYNFILE |\
      awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
      grep -v \\$ | sort -n -k 2 | tail -n1 | awk '{printf("%d",$2)}'
  }

  DYNFILE=`dirname $SECFORC`/*.dyn
  NR_NODE=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_NEXT=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 "^${NR_NODE}$" | grep -v "^${NR_NODE}$"`
  X_MIN=`getxmin`
  X_MAX=`getxmax`
  LENGTH=`expr $X_MAX - $X_MIN`

  ORIG=`cat $SECFORC | grep line -n | tail -n1 | sed 's/:.*//g'`
  AREA=`cat $SECFORC | awk 'NR=='$ORIG'+3{print $4}'`
  cat $SECFORC | \
    awk '(NR-'$ORIG')%4==1{if($1==1) print $2/'$LENGTH' "," $3/'$AREA'}' \
    > ${SECFORC}.csv
fi

