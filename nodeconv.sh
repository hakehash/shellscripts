#!/bin/sh

cat $1 | sed -e 's/,/ /g' | awk '{printf "%8d%16.1f%16f%16f%8d%8d\n",$1,$2,$3,$4,$5,$6}'
