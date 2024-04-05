#! /bin/bash
cp -r ./src/* /etc/nixos/
nixos-rebuild switch
