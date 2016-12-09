#!/bin/sh

LATI=3536.0628
LONG=13872.7365
while :
do
  UTC=`date -u +%H%M%S.%N | head -c 10`
  echo \$GPGGA,$UTC,$LATI,N,$LONG,E,2,,,3775.51,M,,M,,*
  echo \$GPGLL,$LATI,N,$LONG,E,$UTC,A,D*
  echo \$GPGSA,A,3,,*
  echo \$GPGSV,,*
  echo \$GPRMC,$UTC,A,$LATI,N,$LONG,E,0.0,0.0,`date -u +%d%m%y`,,,D*
  echo \$GPVTG,0.00,T,,M,0.00,N,0.00,K*
  echo \$GPZDA,$UTC,`date -u +%d`,`date -u +%m`,`date -u +%Y`,`date +%H`,`date +%M`*
  sleep 1
done
