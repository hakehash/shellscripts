#!/bin/sh

gnuplot -p -e 'set terminal pngcairo;
  set output "'`dirname $1`'/secforc.png";
  set monochrome; set xtics 0.001; unset key;
  set ylabel "Stress [MPa]";
  set xlabel "Strain [-]";
  set datafile separator ","; plot "'$1'" w l'

