#!/bin/sh
sh copy_assets.sh
HOST=${1:-$(hostname)}
nix-channel --update
nixos-rebuild switch -I nixos-config=$(pwd)/src/hosts/$HOST.nix --upgrade
