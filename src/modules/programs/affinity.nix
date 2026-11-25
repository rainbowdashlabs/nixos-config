/** Affinity v3 under Wine from mrshmllow/affinity-nix, with its binary cache. */
{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.affinity-nix.overlays.default ];

  nix.settings = {
    extra-substituters = [ "https://cache.forall.systems" ];
    extra-trusted-public-keys = [
      "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
    ];
  };

  environment.systemPackages = [ pkgs.affinity-v3 ];
}
