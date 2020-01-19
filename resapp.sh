#!/bin/sh

if [ $# -lt 2 ] || [ ! -f $1 ]; then
  echo "usage:\t`basename $0` file alpha" 1>&2
else
  a=3160
  b=880
  t=24
  DYNFILE=$1
  ALPHA=$2
  shift 2
  NR_NODE=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_NEXT=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 "^${NR_NODE}$" | grep -v "^${NR_NODE}$"`
  NR_END=`cat $DYNFILE | wc -l`
  PATH_TO_SCRIPTS=`dirname $0`

  cat $DYNFILE |\
    awk 'BEGIN{
        a='$a';
        b='$b';
        t='$t';
        etat=33;
        mesh_size=55;
        NR_NEXT='$NR_END'
      }
      function abs(x){
        return x<0 ? -x:x;
      }
      #/^\*NODE$/{NR_NODE=NR}
      #NR>NR_NODE && NR<NR_NEXT && /^\*/{NR_NEXT=NR; print NR}

      {if(NR>'$NR_NODE' && NR<'$NR_NEXT' && $4==0){
        if(int(abs($3-mesh_size)+0.5)%b==0){
          y=$3-(mesh_size-etat);
          printf("%8d%16G%16G%16G%8d%8d\n",$1,$2,y,$4,$5,$6);
        } else if(int(abs($3)+0.5)%b==0){
          print $0
        } else if(int(abs($3+mesh_size)+0.5)%b==0){
          y=$3+(mesh_size-etat);
          printf("%8d%16G%16G%16G%8d%8d\n",$1,$2,y,$4,$5,$6);
        } else if(int(abs($3)+0.5)%(b/2)==0){
          print $0;
        }
      } else {
        #print $0;
      }}'
fi

