#!/bin/bash

URL="https://maker.ifttt.com/trigger"
EVENTNAME="Analysis_Completed"
#EVENTNAME="sh_tweet"
YOUR_KEY="mPIF3JGH3SZIFUjSmDZovFmzdg3RzvA4Q6OHQ2d2kEm"

WEBHOOKSURL="${URL}/${EVENTNAME}/with/key/${YOUR_KEY}"

VALUE=`cat -`

curl -X POST -H "Content-Type: application/json" -d \
  #'{"EventName":"'$VALUE'"}' ${WEBHOOKSURL}
  '{"value1":"'$VALUE'"}' ${WEBHOOKSURL}
echo
exit 0
