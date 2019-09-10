#!/bin/sh

GLOBAL=0
HORSE=0
LOCAL=0

if [ $# -lt 3 ] || [ ! -f $1 ]; then
  echo "usage:\t`basename $0` file w0max -[ghl]" 1>&2
else
  DYNFILE=$1
  w0max=$2
  while [ $# -gt 2 ]; do
    if [ $3 = "-g" ]; then
      GLOBAL=1
    fi
    if [ $3 = "-h" ]; then
      HORSE=1
    fi
    if [ $3 = "-l" ]; then
      LOCAL=1
    fi
    shift
  done

  ND_NODE=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_NEXT=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 ^$ND_NODE$ | grep -v ^$ND_NODE$`
  DIRNAME=`dirname $0`

  if [ $HORSE -ne 0 ]; then
    cat $DYNFILE | \
      awk '{
        if (NR > '$ND_NODE' && NR < '$NR_NEXT' && $4==0){
          system("'$DIRNAME'/hhorse.pl "sprintf("%d %f %f %f %f",$1,$2,$3,$4,'$w0max'))
        }
        else print$0
      }'
  fi
fi

