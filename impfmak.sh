#!/bin/sh

NR_ND=`awk '/^\*NODE$/{print NR}' $1`
NR_SS=`awk '/^\*/{print NR}' $1 | grep -A1 ^$NR_ND$ | grep -v ^$NR_ND$`

cat $1 | \
awk '{
  if (NR > '$NR_ND' && NR < '$NR_SS'){
    if($4==0) system("./hhorse.pl "sprintf("%d %f %f %f %f",$1,$2,$3,$4,6))
    else print$0
  }
  else print$0
}' > test.dyn

