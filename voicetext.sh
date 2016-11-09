#!/bin/sh

#Write YOUR_API_KEY here.
API_KEY=

#Do not change below.
case $# in
 0)
  echo 'usage: voicetext text [speaker] [emotion] [emotion_level]'
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
esac

unset API_KEY
