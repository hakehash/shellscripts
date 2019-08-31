#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use Math::Trig;

if($#ARGV < 3){
  print STDERR "usage: hhorse.pl nid x y w0max\n"
} else {

  my $l = 3160;
  my $b = 880;
  my $nid =$ARGV[0];
  my $x = $ARGV[1];
  my $y = $ARGV[2];
  my $w0max = $ARGV[3];
  my $sum = 0;

  my @A;
  $A[1] = 1.1458;
  $A[2] = -0.0616;
  $A[3] = 0.3079;
  $A[4] = 0.0229;
  $A[5] = 0.1146;
  $A[6] = -0.0065;
  $A[7] = 0.0327;
  $A[8] = 0.0;
  $A[9] = 0.0;
  $A[10] = -0.0015;
  $A[11] = -0.0074;

  for (my $m = 1; $m < 12; $m++){
    $sum += $A[$m] * sin($m * pi * $x / $l) * sin(pi * $y / $b);
  }

  my $w0 = $w0max * abs( $sum );

  printf "%8d%16f%16f%16f%8d%8d\n",$nid,$x,$y,$w0,0,0;
}
