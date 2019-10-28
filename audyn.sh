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
t_MIN=24
t_STEP=5
t_MAX=24
for t in `seq $t_MIN $t_STEP $t_MAX`
do
  BETA=`echo $t | awk '{print 880/$1*sqrt(313.6/205800)}'`
  w0_SLIGHT=`echo 0.025 | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
  w0_AVERAGE=`echo 0.1 | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
  w0_SEVERE=`echo 0.3 | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
  for w0 in $w0_SLIGHT $w0_AVERAGE $w0_SEVERE
  do
    MOD_FILENAME=${ORIG_FILENAME}_t${t}mm_w${w0}mm_$2
    mkdir $PATH_TO_KEYFILE/${MOD_FILENAME}
    DYNA_I=$PATH_TO_KEYFILE/${MOD_FILENAME}/${MOD_FILENAME}.dyn
    #DYNA_O=$PATH_TO_KEYFILE/${MOD_FILENAME}/d3hsp
    DYNA_O=`dirname $DYNA_I`/d3hsp
    if [ -n "$NR_s" ]; then
      cat $1 | \
      awk '{
        if(NR=='$NR_s+4')
          printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t/2','$t/2','$t/2','$t/2',0,0,0,0
        else if(NR=='$NR_m+4')
          printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
        else
          print$0
      }' > $DYNA_I
    elif [ -n "$NR_m" ]; then
      cat $1 | \
      awk '{
        if(NR=='$NR_m+4')
          printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
        else
          print$0
      }' > $DYNA_I
    else
      cat $1 | \
      awk '{
        if(NR=='$NR_plate+4')
          printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",'$t','$t','$t','$t',0,0,0,0
        else
          print$0
      }' > $DYNA_I
    fi

    $PATH_TO_SCRIPTS/impfmak.sh $DYNA_I $w0 -${2} > tmp.dyn
    cat tmp.dyn > $DYNA_I
    rm tmp.dyn

    #cd $PATH_TO_KEYFILE/${MOD_FILENAME}
    echo $MOD_FILENAME \($ORIG_FILENAME\) started at `date` | tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
    cd `dirname $DYNA_I`
    if [ `uname -r | grep Microsoft` ]; then
      DYNA_I=`echo $DYNA_I | sed 's/\/mnt\/f/F:/' | sed 's/\//\\\\\\\\/g'`
      DYNA_O=`echo $DYNA_O | sed 's/\/mnt\/f/F:/' | sed 's/\//\\\\\\\\/g'`
    elif [ `uname -a | grep Cygwin` ]; then
      DYNA_I=`echo $DYNA_I | sed 's/\/cygdrive\/f/F:/' | sed 's/\//\\\\\\\\/g'`
      DYNA_O=`echo $DYNA_O | sed 's/\/cygdrive\/f/F:/' | sed 's/\//\\\\\\\\/g'`
    fi
    $PATH_TO_LSDYNA$NAME_OF_EXEC I\=$DYNA_I O\=$DYNA_O
    $PATH_TO_SCRIPTS/secf2csv.sh secforc $3
    cd -
    echo $MOD_FILENAME \($ORIG_FILENAME\) terminated at `date` |\
      tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
  done
done
fi

