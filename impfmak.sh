#!/bin/sh

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

  paik1(){
    cat $DYNFILE | \
      awk 'BEGIN{
          a='$a'; b='$b'; pi=atan2(0,-1);
          B1[1] = 1.0;
          B1[2] = -0.0235;
          B1[3] = 0.3837;
          B1[4] = -0.0259;
          B1[5] = 0.2127;
          B1[6] = -0.0371;
          B1[7] = 0.0478;
          B1[8] = -0.0201;
          B1[9] = 0.0010;
          B1[10] = -0.0090;
          B1[11] = 0.0005;
        }
        function abs(x){
          return x<0 ? -x:x;
        }
        {
        if (NR>'$NR_NODE' && NR<'$NR_NEXT' && $4==0 && $1<900000) {
          sum = 0;
          for(m=1;m<12;m++){
            sum += B1[m]*sin(m*pi*$2/a)*sin(pi*$3/b);
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

  paik2(){
    cat $DYNFILE | \
      awk 'BEGIN{
          a='$a'; b='$b'; pi=atan2(0,-1);
          B2[1] = 0.8807;
          B2[2] = 0.0643;
          B2[3] = 0.0344;
          B2[4] = -0.1056;
          B2[5] = 0.0183;
          B2[6] = 0.0480;
          B2[7] = 0.0150;
          B2[8] = -0.0101;
          B2[9] = 0.0082;
          B2[10] = 0.0001;
          B2[11] = -0.0103;
        }
        function abs(x){
          return x<0 ? -x:x;
        }
        {
        if (NR>'$NR_NODE' && NR<'$NR_NEXT' && $4==0 && $1<900000) {
          sum = 0;
          for(m=1;m<12;m++){
            sum += B2[m]*sin(m*pi*$2/a)*sin(pi*$3/b);
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

  while getopts "ghlpqrsa:b:" OPT ; do
    case $OPT in
      h) horse
        ;;
      l) elastic
        ;;
      g) echo This option is not implemented yet.
        ;;
      p) paik1
        ;;
      q) paik2
        ;;
      a) a=$OPTARG
        ;;
      b) b=$OPTARG
        ;;
    esac
  done
fi
