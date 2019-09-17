#!/bin/sh
if [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` /path/to/keywordfile.dyn" 1>&2
else
PATH_TO_LSDYNA=/mnt/c/LSDYNA/program/
#NAME_OF_EXEC=ls-dyna_smp_s_R10.0_winx64_ifort131.exe
NAME_OF_EXEC=ls-dyna_smp_s_R901_winx64_ifort131.exe
PATH_TO_SCRIPTS=`dirname $0`
PATH_TO_KEYFILE=`dirname $1`
ORIG_FILENAME=`basename $1 .dyn`
LOG_FILENAME=autolog.txt
NR_plate=`grep \*SECTION_SHELL_TITLE $1 -A4 -n | grep plate$ | sed 's/[:-].*//g'`
touch $LOG_FILENAME
for t in `seq 50 50 100`
do
  #MOD_FILENAME=`date +%Y%m%dT%H%M%S`_${t}mm
  MOD_FILENAME=${ORIG_FILENAME}_t${t}mm
  mkdir $PATH_TO_KEYFILE/${MOD_FILENAME}
  DYNA_I=$PATH_TO_KEYFILE/${MOD_FILENAME}/${MOD_FILENAME}.dyn
  #DYNA_O=$PATH_TO_KEYFILE/${MOD_FILENAME}/d3hsp
  DYNA_O=`dirname $DYNA_I`/d3hsp
  if [ -n "$NR_s" ]; then
    cat $1 | \
    awk '{
      if(NR=='$NR_s+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t/2','$t/2','$t/2','$t/2',0,0,0,0
      else if(NR=='$NR_m+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
      else print$0
    }' > $DYNA_I
  elif [ -n "$NR_m" ]; then
    cat $1 | \
    awk '{
      if(NR=='$NR_m+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
      else print$0
    }' > $DYNA_I
  else
    cat $1 | \
    awk '{
      if(NR=='$NR_plate+4') printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
      else print$0
    }' > $DYNA_I
  fi
  if [ `uname -r | grep Microsoft` ]; then
    DYNA_I=`echo $DYNA_I | sed 's/\/mnt\/f/F:/' | sed 's/\//\\\\\\\\/g'`
    DYNA_O=`echo $DYNA_O | sed 's/\/mnt\/f/F:/' | sed 's/\//\\\\\\\\/g'`
  elif [ `uname -a | grep Cygwin` ]; then
    DYNA_I=`echo $DYNA_I | sed 's/\/cygdrive\/f/F:/' | sed 's/\//\\\\\\\\/g'`
    DYNA_O=`echo $DYNA_O | sed 's/\/cygdrive\/f/F:/' | sed 's/\//\\\\\\\\/g'`
  fi
  echo $MOD_FILENAME \($ORIG_FILENAME\) started at `date` | tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
  #cd $PATH_TO_KEYFILE/${MOD_FILENAME}
  cd `dirname $DYNA_I`
  $PATH_TO_LSDYNA$NAME_OF_EXEC I\=$DYNA_I O\=$DYNA_O
  $PATH_TO_SCRIPTS/secf2csv.sh secforc
  cd -
  echo $MOD_FILENAME \($ORIG_FILENAME\) terminated at `date` | tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
done
fi

