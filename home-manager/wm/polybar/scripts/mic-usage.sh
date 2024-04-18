#!/bin/sh

if [ -z "${1+x}" ] || [ -z "${2+x}" ]; then
  echo "Usage: $0 <on> <off>"
  exit 1
fi

DEFAULT_SOURCE=$(pactl get-default-source)

pactl --format json list sources \
  | jq -r "map(select(.name == \"$DEFAULT_SOURCE\"))" \
  | jq -r "if .[0].state == \"RUNNING\" then \"$1\" else \"$2\" end"
