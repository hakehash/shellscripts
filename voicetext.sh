#!/bin/sh

# Write YOUR_API_KEY here.
API_KEY=

# You can choose default speaker from
# show, haruka, hikari, takeru, santa, or bear.
SPEAKER=hikari
FORMAT=ogg

#Do not change below.
if [ ! $API_KEY ]; then
  echo 'Please register at https://cloud.voicetext.jp/webapi/api_keys/new' 1>&2
  echo 'and then write YOUR_API_KEY in this script file.' 1>&2
else
  API_URI="https://api.voicetext.jp/v1/tts"
  if [ -p /dev/stdin ]; then
    APITEXT=`cat -`
  elif [ $# -eq 0 ]; then
    echo -e "usage:\t`basename $0` text -[sfelpdv]"
    echo -e "\t\tor"
    echo -e "\tcat script.txt | `basename $0` -[sfelpdv]"
    echo -e " -s speaker\tspeaker"
    echo -e " -f wav|ogg|aac\tformat"
    echo -e " -e emotion\temotion"
    echo -e " -l [1-4]\temotion_level"
    echo -e " -p [50-200]\tpitch(%)"
    echo -e " -d [50-400]\tspeed(%)"
    echo -e " -v [50-200]\tvolume(%)"
  else
    APITEXT=$1
  fi
  while getopts "s:f:e:l:p:d:v:" OPT ; do
    case $OPT in
     s)
      SPEAKER=$OPTARG
     ;;
     f)
      FORMAT=$OPTARG
     ;;
     e)
      EMOTION=$OPTARG
     ;;
     l)
      EMOLEVEL=$OPTARG
     ;;
     p)
      APITCH=$OPTARG
     ;;
     d)
      SPEED=$OPTARG
     ;;
     v)
      VOLUME=$OPTARG
     ;;
    esac
  done
  if [ "$APITEXT" ]; then
    curl $API_URI -u "$API_KEY:" \
    -d "text=$APITEXT" -d "speaker=$SPEAKER" -d "format=$FORMAT" \
    -d "emotion=$EMOTION" -d "emotion_level=$EMOLEVEL" \
    -d "pitch=$APITCH" -d "speed=$SPEED" -d "volume=$VOLUME" | ogg123 -
  fi
fi

