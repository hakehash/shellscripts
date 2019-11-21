#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use Math::Trig;
use File::Basename;

if($#ARGV < 4){
  my $basename = basename $0;
  print STDERR "usage:\t$basename nid x y z w0max tc rc\n"
} else {

  my $a = 3160;
  my $b = 880;
  my $nid =$ARGV[0];
  my $x = $ARGV[1];
  my $y = $ARGV[2];
  my $z = $ARGV[3];
  my $w0max = $ARGV[4];
  my $tc = $ARGV[5];
  my $rc = $ARGV[6];
  my $m = 4;

  my $wpl = $z + $w0max * sin($m * pi * $x / $a) * sin(pi * $y / $b);

  printf "%8d%16f%16f%16f%8d%8d\n",$nid,$x,$y,$wpl,0,0;
  printf "%8d%16f%16f%16f%8d%8d\n",$nid,$x,$y,$w0,$tc,$rc;
}
