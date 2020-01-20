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
        boa=3*b;
        etat=33;
        n=16;
        m=n/2-1;
        mesh_size=(b-2*etat)/2/(n/2-1);
      }
      function abs(x){
        return x<0 ? -x:x;
      }
      #/^\*NODE$/{NR_NODE=NR}
      #NR>NR_NODE && NR<NR_NEXT && /^\*/{NR_NEXT=NR; print NR}

      {if(NR>'$NR_NODE' && NR<'$NR_NEXT' && $4==0 && $1<900000){
        if(int(abs($3)+0.5)%b==0){
          print $0
          for(i=0;i<m;i++){
            printf("%8d%16G%16G%16G%8d%8d\n",$1+i+1,$2,$3+etat+i*mesh_size,$4,$5,$6);
          }
        } else if(int(abs($3)+0.5)%(b/2)==0){
          print $0
          if($3<boa/2){
            for(i=1;i<=m;i++){
              printf("%8d%16G%16G%16G%8d%8d\n",$1+i,$2,$3+i*mesh_size,$4,$5,$6);
            }
          }
        } else {
          #print $0;
        }
      } else {
        print $0;
      }}'
fi

