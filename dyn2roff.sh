#!/bin/sh

echo ".ft C\n.nf"
DYNFILE=$1
NR_ES=`awk '/^\*ELEMENT_SHELL$/{print NR}' $DYNFILE`
NR_EE=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 $NR_ES | grep -v $NR_ES`
NR_ND=`awk '/^\*NODE$/{print NR}' $DYNFILE`
NR_SS=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 $NR_ND | grep -v $NR_ND`
cat $DYNFILE | \
  sed `expr $NR_ES + 1`,`expr $NR_EE - 1`d | \
  sed `expr $NR_ND - \( $NR_EE - $NR_ES \) + 2`,`expr $NR_ES - $NR_EE + $NR_SS`d | \
  sed 's/^\*ELEMENT_SHELL$/&\n-------------------------------->8================================/' | \
  sed 's/^\*NODE$/&\n-------------------------------->8================================/'
