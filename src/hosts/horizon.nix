{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hosts.hardware scan.
      ./hardware/horizon.nix
      ./../modules
    ];

  networking.hostName = "horizon";

  system.stateVersion = "23.11";
}
