#!/bin/sh
sh copy_assets.sh
HOST=${1:-$(hostname)}
nixos-rebuild switch -I nixos-config=$(pwd)/src/hosts/$HOST.nix
