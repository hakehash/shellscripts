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

cat $DYNFILE |\
  awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
  grep -v \\$ | sort -n -k 2 |\
  awk -v "xmin=$X_MIN" -v "xmax=$X_MAX"
  '$2==xmin { print $1 > nodes_id_list_min.tmp }
   $2==xmax { print $1 > nodes_id_list_max.tmp }'

DOF=1
cat nodes_id_list_min.tmp |\
  awk '{
  printf("*CONSTRAINED_LINEAR_GLOBAL\n%10d\n%10d%10d%10.1f\n%10d%10d%10.1f\n",
  '$DOF'*1000+NR, $1, '$DOF', -1, 900004, '$DOF', 1)}'

for DOF in 2 3 5 6
do
paste nodes_id_list_min.tmp nodes_id_list_max.tmp |\
  awk '{
  printf("*CONSTRAINED_LINEAR_GLOBAL\n%10d\n%10d%10d%10.1f\n%10d%10d%10.1f\n",
  '$DOF'*1000+NR, $1, '$DOF', -1, $2, '$DOF', 1)}'
done

