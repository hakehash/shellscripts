#!/bin/sh

cat $1 | sed '/^*END$/d'
`dirname $0`/pbc.sh $1
cat dummy.dyn
