#!/bin/sh

IsLaTeX=0
if [ -p /dev/stdin ]; then
  cat - > .tmp_dyn2roff
  DYNFILE=.tmp_dyn2roff
  while getopts "l" OPT ; do
    case $OPT in
      l)
        IsLaTeX=1
        ;;
    esac
  done
elif [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` file | groff -ms -Tpdf > output.pdf" 1>&2
  echo "\t\tor" 1>&2
  echo "\tcat file | `basename $0` -l > output.tex" 1>&2
else
  while [ $# -ne 0 ]; do
    if [ -f $1 ]; then
      DYNFILE=$1
    fi
    if [ $1 = "-l" ]; then
      IsLaTeX=1
    fi
    shift
  done
fi
if [ "$DYNFILE" ]; then
  NR_ES=`awk '/^\*ELEMENT_SHELL$/{print NR}' $DYNFILE`
  NR_EE=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 ^$NR_ES$ | grep -v ^$NR_ES$`
  NR_ND=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_SS=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 ^$NR_ND$ | grep -v ^$NR_ND$`
  OMITT=--------------------------------\>8--------------------------------
  if [ "$IsLaTeX" -ne 0 ]; then
    echo "\\\\begin{verbatim}"
  else
    echo ".ft C\n.nf"
  fi
  cat $DYNFILE | \
    sed `expr $NR_ES + 1`,`expr $NR_EE - 1`d | \
    sed `expr $NR_ND - \( $NR_EE - $NR_ES \) + 2`,`expr $NR_ES - $NR_EE + $NR_SS`d | \
    sed "s/^\*ELEMENT_SHELL$/&\n$OMITT/" | \
    sed "s/^\*NODE$/&\n$OMITT/"
  if [ "$IsLaTeX" -ne 0 ]; then
    echo "\\\\end{verbatim}"
  fi
fi
if [ -w .tmp_dyn2roff ]; then
  rm .tmp_dyn2roff
fi

