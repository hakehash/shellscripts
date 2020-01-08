#!/bin/sh

GLOBAL=0
HORSE=0
LOCAL=0

if [ $# -lt 3 ] || [ ! -f $1 ]; then
  echo "usage:\t`basename $0` file w0max -[ghl]" 1>&2
else
  a=3160
  b=880
  DYNFILE=$1
  w0max=$2
  shift 2
  NR_NODE=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_NEXT=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 "^${NR_NODE}$" | grep -v "^${NR_NODE}$"`
  PATH_TO_SCRIPTS=`dirname $0`

  horse(){
    cat $DYNFILE | \
      awk 'BEGIN{
          a='$a'; b='$b'; pi=atan2(0,-1);
          A0[1] = 1.1458;
          A0[2] = -0.0616;
          A0[3] = 0.3079;
          A0[4] = 0.0229;
          A0[5] = 0.1146;
          A0[6] = -0.0065;
          A0[7] = 0.0327;
          A0[8] = 0.0;
          A0[9] = 0.0;
          A0[10] = -0.0015;
          A0[11] = -0.0074;
        }
        function abs(x){
          return x<0 ? -x:x;
        }
        {
        if (NR>'$NR_NODE' && NR<'$NR_NEXT' && $4==0 && $1<900000) {
          sum = 0;
          for(m=1;m<12;m++){
            sum += A0[m]*sin(m*pi*$2/a)*sin(pi*$3/b);
          }
          if($2<a || 2*a<$2){
            wpl = $4+'$w0max'*abs(sum)*0.99;
          } else {
            wpl = $4+'$w0max'*abs(sum);
          }
          printf("%8d%16G%16G%16G%8d%8d\n",$1,$2,$3,wpl,$5,$6);
        }
        else print $0
      }'
  }

  elastic(){
    cat $DYNFILE | \
      awk 'BEGIN{a='$a'; b='$b'; m=4; pi=atan2(0,-1)}
        {
        if (NR>'$NR_NODE' && NR<'$NR_NEXT' && $4==0 && $1<900000){
          if($2<a || 2*a<$2){
            wpl = $4+'$w0max'*sin(m*pi*$2/a)*sin(pi*$3/b)*0.99;
          } else {
            wpl = $4+'$w0max'*sin(m*pi*$2/a)*sin(pi*$3/b);
          }
          printf("%8d%16G%16G%16G%8d%8d\n",$1,$2,$3,wpl,$5,$6);
        }
        else print $0
      }'
  }

  while getopts "ghla:b:" OPT ; do
    case $OPT in
      h) horse
        ;;
      l) elastic
        ;;
      g) echo This option is not implemented yet.
        ;;
      a) a=$OPTARG
        ;;
      b) b=$OPTARG
        ;;
    esac
  done
fi
