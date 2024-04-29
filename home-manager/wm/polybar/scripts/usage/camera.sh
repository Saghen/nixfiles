# TODO: should also check pw-dump for wireplumber usage

if [ -z "${1+x}" ] || [ -z "${2+x}" ]; then
  echo "Usage: $0 <on> <off>"
  exit 1
fi

DEVICES_USING_CAMERA=$(lsof /dev/video0 | awk '!/wireplumb/ && NR>1')

if [ -n "$DEVICES_USING_CAMERA" ]; then
  echo "$1"
else
  echo "$2"
fi
