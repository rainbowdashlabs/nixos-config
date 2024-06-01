{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hosts.hardware scan.
      ./hardware/liara.nix
      ./../modules
      <nixos-hardware/framework/16-inch/7040-amd>
    ];

  services.fwupd.enable = true;

  networking.hostName = "liara";

  system.stateVersion = "23.11";
}
