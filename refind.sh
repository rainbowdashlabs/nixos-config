#!/bin/sh
refind-install
cp ./src/efi/refind/ /boot/EFI/ -r

echo "$(cat ./src/efi/extension.conf)" >> /boot/EFI/refind/refind.conf
