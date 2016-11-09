#!/bin/bash

TECH=("BUY" "USE" "BREAK" "FIX"
      "TRASH" "CHANGE" "MAIL" "UPGRADE"
      "CHARGE" "POINT" "ZOOM" "PRESS"
      "SNAP" "WORK" "QUICK" "ERASE"
      "WRITE" "CUT" "PASTE" "SAVE"
      "LOAD" "CHECK" "QUICK" "REWRITE"
      "PLUG" "PLAY" "BURN" "RIP"
      "DRAG" "DROP" "ZIP" "UNZIP"
      "LOCK" "FILL" "CALL" "FIND"
      "VIEW" "CODE" "JAM" "UNLOCK"
      "SURF" "SCROLL" "PAUSE" "CLICK"
      "CROSS" "CRACK" "SWITCH" "UPDATE"
      "NAME" "RATE" "TUNE" "PRINT"
      "SCAN" "SEND" "FAX" "RENAME"
      "TOUCH" "BRING" "PAY" "WATCH"
      "TURN" "LEAVE" "START" "FORMAT")
for ((i=0; i<${#TECH[@]}; i++))
do
clear ; echo ${TECH[i]} | figlet -c ; sleep 0.4
done
unset TECH ; clear
