{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hosts.hardware scan.
      ./hardware/shepard.nix
      ./../modules
    ];

  networking.hostName = "shepard";

  system.stateVersion = "23.11";
}
