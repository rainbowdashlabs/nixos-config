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
        sha256 = "8ebc65af0cfc891ba63dce0546583da728434db0f5f6a54d979f25ec47f548b3";
      };
      version = "6.6.9";
      modDirVersion = "6.6.9";
    };
  });


  system.stateVersion = "23.11";
}
