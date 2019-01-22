#!/bin/bash

p[0]="_1 _2 _3 _4 _5 _6 _7 _8 _9 10 11 12 _13 14 _15 16 _17 _18\n"
p[1]="_H __ __ __ __ __ __ __ __ __ __ __ ___ __ ___ __ ___ _He\n"
p[2]="Li Be __ __ __ __ __ __ __ __ __ __ __B _C __N _O __F _Ne\n"
p[3]="Na Mg __ __ __ __ __ __ __ __ __ __ _Al Si __P _S _Cl _Ar\n"
p[4]="_K Ca Sc Ti _V Cr Mn Fe Co Ni Cu Zn _Ga Ge _As Se _Br _Kr\n"
p[5]="Rb Sr _Y Zr Nb Mo Tc Ru Rh Pd Ag Cd _In Sn _Sb Te __I _Xe\n"
p[6]="Cs Ba La Hf Ta _W Re Os Ir Pt Au Hg _Tl Pb _Bi Po _At _Rn\n"
p[7]="Fr Ra Ac Rf Db Sg Bh Hs Mt Ds Rg Cn Uut Fl Uup Lv Uus Uuo"
la="\nLanthanide: La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu\n"
ac="__Actinoid: Ac Th Pa _U Np Pu Am Cm Bk Cf Es Fm Md No Lr"

if test $# -eq 0
 then
 echo -e _${p[@]} | sed 's/_/ /g'
 echo -e $la$ac | sed 's/_/ /g'
elif test $1 -eq 3
 then
 echo -e ${p[@]} | awk '{print $3}' | sed 's/_/ /g'
 echo -e $la$ac | sed 's/_/ /g'
else
 echo -e ${p[@]} | awk -v num=$1 '{print $num}' | sed 's/_/ /g'
fi

