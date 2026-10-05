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
{
  imports =
    [ # Include the results of the hosts.hardware scan.
      ./hardware/liara.nix
      ./../modules
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ];

  services.fwupd.enable = true;

  networking.hostName = "liara";

  environment.systemPackages = [
    pkgs.ultrastardx
    citrixPkgs.citrix_workspace
  ];

  system.stateVersion = "23.11";
}
