{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hosts.hardware scan.
      ./hardware/shepard.nix
      ./../modules
      ./../modules/graphics/nvidia.nix
    ];

  networking.hostName = "shepard";

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "d1054ab4803413efe2850f50f1a84349c091631ec50a1cf9e891d1b1f9061835";
      };
      version = "6.6.63";
      modDirVersion = "6.6.63";
    };
  });


  system.stateVersion = "23.11";
}
