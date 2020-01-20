#!/bin/sh
if [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` /path/to/keywordfile.dyn [ytnilhso]" 1>&2
else
  PATH_TO_LSDYNA=/mnt/c/LSDYNA/program/
  #NAME_OF_EXEC=ls-dyna_smp_s_R10.0_winx64_ifort131.exe
  NAME_OF_EXEC=ls-dyna_smp_s_R901_winx64_ifort131.exe
  PATH_TO_SCRIPTS=`cd $(dirname $0) && cd -`
  PATH_TO_KEYFILE=`dirname $1`
  ORIG=$1
  ORIG_FILENAME=`basename $1 .dyn`
  shift
  LOG_FILENAME=autolog.txt

  t=24
  SIGY=363.77
  BETA=`awk 'BEGIN{print 880/'$t'*sqrt('$SIGY'/205800)}'`
  w0=2.85173
  #w0_SLIGHT=`echo 0.025 | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
  #w0_AVERAGE=`echo 0.1 | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
  #w0_SEVERE=`echo 0.3 | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
  #for w0 in $w0_SLIGHT $w0_AVERAGE $w0_SEVERE
  ALPHA=0.05
  #MOD_FILENAME=${ORIG_FILENAME}_${SIGY}MPa_w${w0}mm_$2

  init(){
    touch $PATH_TO_KEYFILE/$LOG_FILENAME
    mkdir $PATH_TO_KEYFILE/${MOD_FILENAME}
    DYNA_I=$PATH_TO_KEYFILE/${MOD_FILENAME}/${MOD_FILENAME}.dyn
    DYNA_O=`dirname $DYNA_I`/d3hsp
  }

  run(){
    echo $MOD_FILENAME started \ \ \ at `date` |\
      tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
    $PATH_TO_SCRIPTS/rundyn.sh $DYNA_I
    echo $MOD_FILENAME terminated at `date` |\
      tee -a $PATH_TO_KEYFILE/$LOG_FILENAME 1>&2
  }

  yield(){
    for SIGY in `seq 309.23 9.09 418.31` #-3sigma to 3sigma
    do
      MOD_FILENAME=${ORIG_FILENAME}_${SIGY}MPa
      init
      cat $ORIG | awk '/\*MAT_PLASTIC_KINEMATIC/{NR_MAT3=NR+2}
      {if(NR==NR_MAT3)
        printf "%10d%10G%10.1f%10.1f%10.2f%10.2f%10.1f\n",
        $1,$2,$3,$4,'$SIGY',$6,$7;
      else
        print $0}' > $DYNA_I
      run
    done
  }

  #NR_plate=`grep \*SECTION_SHELL_TITLE $1 -A4 -n | grep plate$ | sed 's/[:-].*//g'`
  t(){
    for t in `seq 24 1 24`
    do
      MOD_FILENAME=${ORIG_FILENAME}_t${t}mm_w${w0}mm_$2
      init
      if [ -n "$NR_plate" ]; then
        cat $ORIG | \
        awk '{
          if(NR=='$NR_plate+4')
            printf "%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f%10d\n",
            '$t','$t','$t','$t',0,0,0,0
          else
            print$0
        }' > $DYNA_I
      fi
      run
    done
  }

  nip(){
    for NIP in `seq 3 10`
    do
      if [ $1 = 0 ]; then
        INTGRD="gauss"
      elif [ $1 = 1 ]; then
        INTGRD="lobatto"
      fi
      MOD_FILENAME=${ORIG_FILENAME}_${INTGRD}_$NIP
      init
      cat $ORIG | awk '
        /\*CONTROL_SHELL/{NR_CS=NR+4}
        /\*SECTION_SHELL_TITLE/{NR_SS=NR+3}
        {
        if(NR==NR_CS)
          printf "%10.1f%10d%10d%10d%10d\n",
          $1,'$1',$3,$4,$5;
        else if(NR==NR_SS)
          printf "%10d%10d%10.1f%10d%10.1f%10d%10d%10d\n",
          $1,$2,$3,'$NIP',$5,$6,$7,$8;
        else
          print $0
        }' > $DYNA_I
      run
    done
  }

  impf(){
    for ALPHA in `seq 0.014 0.018 0.158` #-sigma to 3sigma
    do
      w0=`echo $ALPHA | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
      MOD_FILENAME=${ORIG_FILENAME}_w${w0}mm_$1
      init
      $PATH_TO_SCRIPTS/impfmak.sh $ORIG $w0 -${1} > $DYNA_I
      run
    done
  }

  impf_smith(){
    for ALPHA in 0.025 0.05 0.1 0.3
    do
      w0=`echo $ALPHA | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
      MOD_FILENAME=${ORIG_FILENAME}_w${w0}mm_$1
      init
      $PATH_TO_SCRIPTS/impfmak.sh $ORIG $w0 -${1} > $DYNA_I
      run
    done
  }

  origin(){
    w0=0.00
    MOD_FILENAME=${ORIG_FILENAME}_w${w0}mm
    init
    cat $ORIG > $DYNA_I
    run
  }

  residual(){
    for ALPHA in 0.025 0.05 0.1 0.3
    do
      w0=`echo $ALPHA | awk '{print $1*'$BETA'*'$BETA'*'$t'}'`
      MOD_FILENAME=${ORIG_FILENAME}_w${w0}mm_$1_res
      init
      $PATH_TO_SCRIPTS/resapp.sh $ORIG $ALPHA > tmp.dyn
      $PATH_TO_SCRIPTS/impfmak.sh tmp.dyn $w0 -${1} > $DYNA_I
      rm tmp.dyn
    done
    run
  }

  while getopts "ytnilhosr" OPT ; do
    case $OPT in
      y) yield
        ;;
      t) t
        ;;
      n) nip 0
         nip 1
        ;;
      i) origin
         impf l
         impf h
        ;;
      l) impf l
        ;;
      h) impf h
        ;;
      o) origin
        ;;
      s) impf_smith l
         impf_smith h
        ;;
      r) residual l
         residual h
        ;;
    esac
  done
fi

