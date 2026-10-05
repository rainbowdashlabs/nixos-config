{ pkgs, ... }:

{
  environment.systemPackages = [ (import ../../packages/threema-desktop { inherit pkgs; }) ];
}
