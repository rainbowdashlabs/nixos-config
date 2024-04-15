#!/bin/sh
nixos-rebuild switch -I nixos-config=$(pwd)/src/hosts/$(hostname).nix
