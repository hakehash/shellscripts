#!/bin/sh

gnuplot -p -e 'set terminal pngcairo;
  set output "'`dirname $1`'/secforc.png";
  set monochrome; set xtics 0.001; unset key;
  set ylabel "応力 [MPa]";
  set xlabel "ひずみ [-]";
  set datafile separator ","; plot "'$1'" w l'

