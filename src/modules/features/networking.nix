{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
        enable = true;
        allowedTCPPorts = [ 3000 ];
    };
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
}
