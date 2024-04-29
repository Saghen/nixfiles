if [ -z "${1+x}" ] || [ -z "${2+x}" ]; then
  echo "Usage: $0 <on> <off>"
  exit 1
fi

pw-dump \
  | jq 'any(select(.type == "PipeWire:Interface:Node") | .info | select(.props."media.class" == "Audio/Source") and select(.state == "running"))' \
  | jq -r "if . then \"$1\" else \"$2\" end"
