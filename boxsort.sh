#!/bin/sh

cat - | awk '
  function abs(x){
    return x<0 ? -x:x;
  }
  function round(x){
    return int(abs(x)+0.5);
  }
  {
    name[NR]=$1;
    ulstrength[NR]=$2;
    count[NR]=round($3*1000);
    if(count[NR]<1){
      count[NR]=1;
    }
    NRE=NR;
  }
  END{
    for(i=1;i<=NRE;i++){
      for(j=0;j<count[i];j++){
        print name[i],ulstrength[i];
      }
    }
  }'
