{ config, lib, pkgs, inputs, ... }:

let
  # Citrix Workspace is unfree, and it links against libsoup 2.x, which nixpkgs marks insecure.
  # Both exceptions live in a separate nixpkgs import so the rest of the system keeps the normal
  # insecure-package check instead of `nixpkgs.config.permittedInsecurePackages` opening libsoup
  # up everywhere. Matched by name rather than by the exact `libsoup-2.74.3`, so a channel bump
  # to the next 2.x point release does not turn this back into a build failure.
  #
  # The tarball itself cannot be fetched by Nix: `src` is a `requireFile`, because downloading it
  # means accepting the Citrix EULA by hand. It has to be in the store before this evaluates:
  #
  #   nix-prefetch-url file://$PWD/linuxx64-<version>.tar.gz
  #
  # after downloading the 64-bit .tar.gz from
  # https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html
  citrixPkgs = import inputs.nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;
    config = {
      allowUnfree = true;
      allowInsecurePredicate = pkg: lib.getName pkg == "libsoup";
    };
  };
in
{  imports =
    [
      # Include the results of the hosts.hardware scan.
      ./hardware/shepard.nix
      ./../modules
      ./../modules/graphics/nvidia.nix
    ];

  networking.hostName = "shepard";

#  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_6.override {
#    argsOverride = rec {
#      src = pkgs.fetchurl {
#        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
#        sha256 = "d1054ab4803413efe2850f50f1a84349c091631ec50a1cf9e891d1b1f9061835";
#      };
#      version = "6.6.63";
#      modDirVersion = "6.6.63";
#    };
#  });

  environment.systemPackages = [
    citrixPkgs.citrix_workspace
  ];


  system.stateVersion = "23.11";
}
