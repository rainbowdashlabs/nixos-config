{pkgs}: let
  inherit (pkgs) lib;
  electronMajor = "40";

  electronPkgs = import pkgs.path {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowInsecurePredicate = pkg: lib.getName pkg == "electron" && lib.versions.major (lib.getVersion pkg) == electronMajor;
  };
in
  pkgs.callPackage ./package.nix {electron = electronPkgs."electron_${electronMajor}";}
