#!/bin/bash

URL="https://maker.ifttt.com/trigger"
EVENTNAME="Analysis_Completed"
#EVENTNAME="sh_tweet"
#YOUR_KEY="mPIF3JGH3SZIFUjSmDZovFmzdg3RzvA4Q6OHQ2d2kEm"
YOUR_KEY="c5s87_RqKNFlOr7XurgHcT"

WEBHOOKSURL="${URL}/${EVENTNAME}/with/key/${YOUR_KEY}"

VALUE=`cat -`

curl -X POST -H "Content-Type: application/json" -d \
  '{"value1":"'$VALUE'"}' ${WEBHOOKSURL}
  #'{"EventName":"'$VALUE'"}' ${WEBHOOKSURL}
echo
exit 0
