#!/bin/sh
sh copy_assets.sh
sh channel.sh
HOST=${1:-$(hostname)}
nixos-rebuild boot -I nixos-config=$(pwd)/src/hosts/$HOST.nix --upgrade

