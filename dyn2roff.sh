#!/bin/sh

if [ -p /dev/stdin ]; then
  DYNFILE=`cat -`
elif [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` file | groff -ms -Tpdf > output.pdf" 1>&2
else
  DYNFILE=$1
fi
if [ "$DYNFILE" ]; then
  NR_ES=`awk '/^\*ELEMENT_SHELL$/{print NR}' $DYNFILE`
  NR_EE=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 $NR_ES | grep -v $NR_ES`
  NR_ND=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_SS=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 $NR_ND | grep -v $NR_ND`
  OMITT=--------------------------------\>8--------------------------------
  echo ".ft C\n.nf"
  cat $DYNFILE | \
    sed `expr $NR_ES + 1`,`expr $NR_EE - 1`d | \
    sed `expr $NR_ND - \( $NR_EE - $NR_ES \) + 2`,`expr $NR_ES - $NR_EE + $NR_SS`d | \
    sed "s/^\*ELEMENT_SHELL$/&\n$OMITT/" | \
    sed "s/^\*NODE$/&\n$OMITT/"
fi

