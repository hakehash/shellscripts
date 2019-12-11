#!/bin/sh

gnuplot -p -e 'set terminal pngcairo;
  set output "secforc.png";
  set monochrome; set xtics 0.001; unset key;
  set xlabel "ひずみ [-]";
  set ylabel "応力 [MPa]";
  set datafile separator ","; plot "'$1'" w l'

