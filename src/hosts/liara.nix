{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hosts.hardware scan.
      ./hardware/liara.nix
      ./../modules
    ];

  networking.hostName = "liara";

  system.stateVersion = "23.11"; # Did you read the comment?
}
