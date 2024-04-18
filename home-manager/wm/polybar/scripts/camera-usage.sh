#!/bin/sh

if [ -z "${1+x}" ] || [ -z "${2+x}" ]; then
  echo "Usage: $0 <on> <off>"
  exit 1
fi

if lsof /dev/video0 >/dev/null 2>&1; then
    echo "$1"
else

