#!/bin/sh
nixos-rebuild switch -I nixos-config=$(pwd)/src/configuration.nix
