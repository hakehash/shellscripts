#!/bin/sh

echo ".ft C\n.nf"
DYNFILE=$1
NR_ES=`awk '/^\*ELEMENT_SHELL$/{print NR}' $DYNFILE`
NR_ND=`awk '/^\*NODE$/{print NR}' $DYNFILE`
NR_SS=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 $NR_ND | grep -v $NR_ND`
cat $DYNFILE | \
  sed `expr $NR_ES + 1`,`expr $NR_ND - 1`d | \
  sed `expr $NR_ES + 3`,`expr $NR_ES + $NR_SS - $NR_ND`d | \
  sed 's/^\*ELEMENT_SHELL$/&\n.DS C\n(omitted)\n.DE\n/' | \
  sed 's/^\*NODE$/&\n.DS C\n(omitted)\n.DE\n/'

