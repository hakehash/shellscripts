#!/bin/sh

DYNFILE=$1
NR_NODE=`awk '/^\*NODE$/{print NR}' $DYNFILE`
NR_NEXT=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 ^${NR_NODE}$ | grep -v ^${NR_NODE}$`
PATH_TO_SCRIPTS=`dirname $0`

getxmin(){
  cat $DYNFILE |\
    awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
    grep -v \\$ | sort -n -k 2 | head -n1 | awk '{print $2}'
}

getxmax(){
  cat $DYNFILE |\
    awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
    grep -v \\$ | sort -n -k 2 | tail -n1 | awk '{print $2}'
}

X_MIN=`getxmin`
X_MAX=`getxmax`

echo $X_MIN
echo $X_MAX

#cat $DYNFILE | awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' | grep -v \\$ | sort -n -k 2

