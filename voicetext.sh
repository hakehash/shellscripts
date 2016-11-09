#!/bin/sh

#Write YOUR_API_KEY here.
API_KEY=

#Do not change below.
case $# in
 0)
  if [ ! $API_KEY ]; then
    echo 'Please register at https://cloud.voicetext.jp/webapi/api_keys/new'
    echo 'and then write YOUR_API_KEY in this script file.' 
  else
    echo 'usage: '
    echo "$ `basename $0` text [speaker] [emotion] [emotion_level] [pitch] [speed] [volume]"
  fi
 ;;
 1)
  curl "https://api.voicetext.jp/v1/tts" -u "$API_KEY:" -d "text=$1" -d "speaker=haruka" | play -
 ;;
 2)
  curl "https://api.voicetext.jp/v1/tts" -u "$API_KEY:" -d "text=$1" -d "speaker=$2" | play -
 ;;
 3)
  curl "https://api.voicetext.jp/v1/tts" -u "$API_KEY:" -d "text=$1" -d "speaker=$2" -d "emotion=$3" | play -
 ;;
 4)
  curl "https://api.voicetext.jp/v1/tts" -u "$API_KEY:" -d "text=$1" -d "speaker=$2" -d "emotion=$3" -d "emotion_level=$4" | play -
 ;;
 5)
  curl "https://api.voicetext.jp/v1/tts" -u "$API_KEY:" -d "text=$1" -d "speaker=$2" -d "emotion=$3" -d "emotion_level=$4" -d "pitch=$5" | play -
 ;;
 6)
  curl "https://api.voicetext.jp/v1/tts" -u "$API_KEY:" -d "text=$1" -d "speaker=$2" -d "emotion=$3" -d "emotion_level=$4" -d "pitch=$5" -d "speed=$6" | play -
 ;;
 7)
  curl "https://api.voicetext.jp/v1/tts" -u "$API_KEY:" -d "text=$1" -d "speaker=$2" -d "emotion=$3" -d "emotion_level=$4" -d "pitch=$5" -d "speed=$6" -d "volume=$7" | play -
 ;;
esac

unset API_KEY
