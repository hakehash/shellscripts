#!/bin/sh

ORIG=`cat $1 | grep line -n | tail -n1 | sed -e 's/:.*//g'`
cat $1 | awk '{if((NR-'$ORIG')%4==1) print $2 "," $3}' > `echo $1.csv`
