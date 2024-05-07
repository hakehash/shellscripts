#!/bin/sh
if [ $# -eq 0 ]; then
  echo "usage:\t`basename $0` -o /path/to/output.m4a -i https://url.to/streaming/audio.m3u8" 1>&2
else
  while getopts "i:o:" OPT ; do
    case $OPT in
      i) INPUT=$OPTARG
        ;;
      o) OUTPUT=$OPTARG
        ;;
    esac
  done
  if [${OUTPUT#*.} -eq "m4a"]; then
    ffmpeg -http_seekable 0 -i $INPUT -vn -c copy $OUTPUT
  else
    ffmpeg -http_seekable 0 -i $INPUT $OUTPUT
  fi
fi
