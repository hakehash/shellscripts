#!/bin/sh

if [ $# -lt 2 ] || [ ! -f $1 ]; then
  echo "usage:\t`basename $0` file alpha" 1>&2
else
  a=3160
  b=880
  t=24
  n=16
  SIGY=363.77
  DYNFILE=$1
  ALPHA=$2
  shift 2
  NR_NODE=`awk '/^\*NODE$/{print NR}' $DYNFILE`
  NR_NEXT=`awk '/^\*/{print NR}' $DYNFILE | grep -A1 "^${NR_NODE}$" | grep -v "^${NR_NODE}$"`
  NR_END=`cat $DYNFILE | wc -l`
  PATH_TO_SCRIPTS=`dirname $0`

  case $ALPHA in
    0.025) LEVEL=-0.05
      ;;
    0.05) LEVEL=-0.09
      ;;
    0.1) LEVEL=-0.15
      ;;
    0.3) LEVEL=-0.3
      ;;
    *) LEVEL=`awk 'BEGIN{print 0-2.24*'$ALPHA'+9.67*'$ALPHA'*'$ALPHA'-22.82*'$ALPHA'*'$ALPHA'*'$ALPHA'}'`
      ;;
  esac

  cat $DYNFILE |\
    awk 'BEGIN{
        a='$a';
        b='$b';
        t='$t';
        boa=3*b;
        SIGY='$SIGY';
        SIGr='$LEVEL'*SIGY;
        bt=b*SIGr/(SIGr-SIGY)/2;
        n='$n';
        m=n/2-1;
        mesh_size=(b-2*bt)/2/(n/2-1);
      }
      function abs(x){
        return x<0 ? -x:x;
      }

      !/^\*END$/{if(NR>'$NR_NODE' && NR<'$NR_NEXT' && $4==0 && $1<900000){
        if(int(abs($3)+0.5)%b==0){
          print $0
          for(i=0;i<m;i++){
            printf("%8d%16G%16G%16G%8d%8d\n",$1+i+1,$2,$3+bt+i*mesh_size,$4,$5,$6);
          }
        } else if(int(abs($3)+0.5)%(b/2)==0){
          if($3<boa/2){
            for(i=0;i<=m;i++){
              printf("%8d%16G%16G%16G%8d%8d\n",$1+i,$2,$3+i*mesh_size,$4,$5,$6);
            }
          } else {
            print $0;
          }
        }
      } else {
        print $0;
      }}

      /^\*END$/{
        print "*INITIAL_STRESS_SHELL_SET"
        printf("%10d%10d%10d%10d%10d%10d\n",2,4,2,0,0,0);
        for(i=-1;i<=1;i+=2){
          ip=0.5773503;
          for(j=0;j<4;j++){
            printf("%10.7f%10g%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f\n",ip*i,SIGY,0,0,0,0,0,0);
          }
        }
        print "*INITIAL_STRESS_SHELL_SET"
        printf("%10d%10d%10d%10d%10d%10d\n",3,4,2,0,0,0);
        for(i=-1;i<=1;i+=2){
          ip=0.5773503;
          for(j=0;j<4;j++){
            printf("%10.7f%10g%10.1f%10.1f%10.1f%10.1f%10.1f%10.1f\n",ip*i,SIGr,0,0,0,0,0,0);
          }
        }
        print "*END"
      }'
fi

