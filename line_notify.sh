#!/bin/bash

URL="https://maker.ifttt.com/trigger"
EVENTNAME="Analysis_Completed"
YOUR_KEY="c5s87_RqKNFlOr7XurgHcT"

WEBHOOKSURL="${URL}/${EVENTNAME}/with/key/${YOUR_KEY}"

VALUE1=$1
VALUE2=`cat -`

curl -X POST -H "Content-Type: application/json" -d \
  '{"value1":"'$VALUE1'", "value2":"'$VALUE2'"}' ${WEBHOOKSURL}
echo
exit 0
