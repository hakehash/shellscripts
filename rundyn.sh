#!/bin/sh

if [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` /path/to/keywordfile.dyn ..." 1>&2
else
PATH_TO_LSDYNA=/mnt/c/LSDYNA/program/
NAME_OF_EXEC=ls-dyna_smp_s_R901_winx64_ifort131.exe
PATH_TO_SCRIPTS=`dirname $0`
LOG_FILENAME=autolog.txt
while [ $# -ne 0 ]; do
  if [ -f $1 ]; then
    PATH_TO_KEYFILE=`dirname $1`
    DYNA_I=$PATH_TO_KEYFILE/$1
    DYNA_O=`dirname $DYNA_I`/d3hsp

    cd `dirname $DYNA_I`
    echo $1 started at `date` |\
      tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
    if [ `uname -r | grep Microsoft` ]; then
      DYNA_I=`echo $DYNA_I | sed 's/\/mnt\/f/F:/' | sed 's/\//\\\\\\\\/g'`
      DYNA_O=`echo $DYNA_O | sed 's/\/mnt\/f/F:/' | sed 's/\//\\\\\\\\/g'`
    elif [ `uname -a | grep Cygwin` ]; then
      DYNA_I=`echo $DYNA_I | sed 's/\/cygdrive\/f/F:/' | sed 's/\//\\\\\\\\/g'`
      DYNA_O=`echo $DYNA_O | sed 's/\/cygdrive\/f/F:/' | sed 's/\//\\\\\\\\/g'`
    fi
    $PATH_TO_LSDYNA$NAME_OF_EXEC I\=$DYNA_I O\=$DYNA_O
    $PATH_TO_SCRIPTS/secf2csv.sh secforc
    echo terminated at `date` |\
      tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
    cat secforc.csv | sort -t "," -r -n -k 2 | head -n1 |\
      tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
    cd -
  fi
  shift
done
