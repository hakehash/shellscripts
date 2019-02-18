#!/bin/sh
if [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` /path/to/keywordfile.dyn"
else
PATH_TO_LSDYNA=/mnt/d/LSDYNA/program/
NAME_OF_EXEC=ls-dyna_smp_s_R10.0_winx64_ifort131.exe
PATH_TO_KEYFILE=`dirname $1`
KEYWORD_FILENAME=`basename $1`
NR_m=`grep \*SECTION_SHELL_TITLE $1 -A4 -n | grep wall$ | sed -e 's/-.*//g'`
NR_s=`grep \*SECTION_SHELL_TITLE $1 -A4 -n | grep wall_side | sed -e 's/-.*//g'`
for t in `seq 2 9`
do
  YmdHMS=`date +%Y%m%dT%H%M%S`_${t}mm
  mkdir $PATH_TO_KEYFILE/${YmdHMS}
  DYNA_I=$PATH_TO_KEYFILE/${YmdHMS}/$KEYWORD_FILENAME
  DYNA_O=$PATH_TO_KEYFILE/${YmdHMS}/d3hsp
  if [ -n "$NR_s" ]; then
    cat $1 | \
    awk '{
      if(NR=='$NR_s+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t/2','$t/2','$t/2','$t/2',0,0,0,0
      else if(NR=='$NR_m+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
      else print$0
    }' > $DYNA_I
  else
    cat $1 | \
    awk '{
      if(NR=='$NR_m+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
      else print$0
    }' > $DYNA_I
  fi
  if [ `uname -r | grep Microsoft` ]; then
    DYNA_I=`echo $DYNA_I | sed  -e 's/\/mnt\/f/F:/' | sed -e 's/\//\\\\\\\\/g'`
    DYNA_O=`echo $DYNA_O | sed  -e 's/\/mnt\/f/F:/' | sed -e 's/\//\\\\\\\\/g'`
  fi
  cd $PATH_TO_KEYFILE/${YmdHMS}
  $PATH_TO_LSDYNA$NAME_OF_EXEC I\=$DYNA_I O\=$DYNA_O
  `dirname $0`/secf2csv.sh secforc
  cd -
  echo $YmdHMS \($KEYWORD_FILENAME\) done at `date` | tee -a $PATH_TO_KEYFILE/autolog.txt
done
fi

