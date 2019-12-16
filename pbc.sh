#!/bin/sh

if [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` keywordfile.dyn" 1>&2
else
  DYNFILE=$1
  NR_NODE=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_NEXT=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 ^${NR_NODE}$ | grep -v ^${NR_NODE}$`

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

  getymin(){
    cat $DYNFILE |\
      awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
      grep -v \\$ | sort -n -k 3 | head -n1 | awk '{print $3}'
  }

  getymax(){
    cat $DYNFILE |\
      awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
      grep -v \\$ | sort -n -k 3 | tail -n1 | awk '{print $3}'
  }

  X_MIN=`getxmin`
  X_MAX=`getxmax`
  Y_MIN=`getymin`
  Y_MAX=`getymax`

  cat $DYNFILE |\
    awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
    grep -v \\$ | sort -n -k 2 |\
    awk -v "xmin=$X_MIN" -v "xmax=$X_MAX" \
    '$2==xmin { print $1 > "nodes_id_list_xmin.tmp" }
     $2==xmax { print $1 > "nodes_id_list_xmax.tmp" }'

  cat $DYNFILE |\
    awk '{if(NR > '$NR_NODE' && NR < '$NR_NEXT'){ print $0 }}' |\
    grep -v \\$ | sort -n -k 3 |\
    awk -v "ymin=$Y_MIN" -v "ymax=$Y_MAX" \
    '$3==ymin { print $1 > "nodes_id_list_ymin.tmp" }
     $3==ymax { print $1 > "nodes_id_list_ymax.tmp" }'

  DOF=1
  cat nodes_id_list_xmin.tmp |\
    awk '{
    printf("*CONSTRAINED_LINEAR_GLOBAL\n%10d\n%10d%10d%10.1f\n%10d%10d%10.1f\n",
    '$DOF'*1000+NR, $1, '$DOF', -1, 900004, '$DOF', 1)}'

  for DOF in 2 3 5 6
  do
  paste nodes_id_list_xmin.tmp nodes_id_list_xmax.tmp |\
    awk '{
    printf("*CONSTRAINED_LINEAR_GLOBAL\n%10d\n%10d%10d%10.1f\n%10d%10d%10.1f\n",
    '$DOF'*1000+NR, $1, '$DOF', -1, $2, '$DOF', 1)}'
  done

  for DOF in 1 3 4 6
  do
  paste nodes_id_list_ymin.tmp nodes_id_list_ymax.tmp |\
    awk '{
    printf("*CONSTRAINED_LINEAR_GLOBAL\n%10d\n%10d%10d%10.1f\n%10d%10d%10.1f\n",
    '$DOF'*10000+NR, $1, '$DOF', -1, $2, '$DOF', 1)}'
  done

  rm nodes_id_list_*.tmp
fi
