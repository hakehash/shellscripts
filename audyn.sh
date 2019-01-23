#!/bin/sh

PATH_TO_LSDYNA=/mnt/d/LSDYNA/programs/
NAME_OF_EXEC=ls-dyna_smp_s_R10.0_winx64_ifort131.exe
PATH_TO_KEYFILE=`dirname $1`
KEYWORD_FILENAME=`basename $1`
NR=`grep \*SECTION_SHELL_TITLE $1 -A4 -n | grep wall$ | sed -e 's/-.*//g'`
for t in `seq 3 9`
do
  YmdHMS=`date +%Y%m%dT%H%M%S`
  mkdir $PATH_TO_KEYFILE/${YmdHMS}_${t}mm
  DYNA_I=$PATH_TO_KEYFILE/${YmdHMS}_${t}mm/$KEYWORD_FILENAME
  DYNA_O=$PATH_TO_KEYFILE/${YmdHMS}_${t}mm/d3hsp
  cat $1 | \
    awk '{
      if(NR=='$NR+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
      else print$0}' \
    > $DYNA_I
  $PATH_TO_LSDYNA$NAME_OF_EXEC I\=$DYNA_I O\=$DYNA_O
  echo ${t}mm done. >> $PATH_TO_KEYFILE/autolog.txt
done

