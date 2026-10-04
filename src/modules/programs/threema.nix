{ pkgs, ... }:

{
  environment.systemPackages = [ (pkgs.callPackage ../../packages/threema-desktop/package.nix { }) ];
}
