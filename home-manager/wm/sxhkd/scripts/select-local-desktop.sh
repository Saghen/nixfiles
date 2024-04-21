#!/bin/bash
bspc $1 $(bspc query --desktops -m "focused" | sed -n "$2p") ${@:3}
