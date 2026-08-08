{ ... }:

{
  # The module and the package come from the deployed assets, where the build script copies
  # nix-assets before rebuilding — the same place xserver.nix and openvpn.nix read theirs from.
  imports = [ /etc/nixos/assets/mymcp/module.nix ];

  services.mymcp.enable = true;
}
