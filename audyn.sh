#!/bin/sh

PATH_TO_LSDYNA=/mnt/d/LSDYNA/programs/
NAME_OF_EXEC=ls-dyna_smp_s_R10.0_winx64_ifort131.exe
PATH_TO_KEYFILE=`dirname $1`
KEYWORD_FILENAME=`basename $1`

for i in `seq 3 9`
do
  YmdHMS=`date +%Y%m%d%H%M%S%N`
  DYNA_I=$PATH_TO_KEYFILE/$YmdHMS/$KEYWORD_FILENAME
  DYNA_O=$PATH_TO_KEYFILE/$YmdHMS/d3hsp
  echo $PATH_TO_LSDYNA$NAME_OF_EXEC I\=$DYNA_I O\=$DYNA_O
done

