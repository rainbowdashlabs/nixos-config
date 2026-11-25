/**
  Affinity v3 under Wine from mrshmllow/affinity-nix, with its binary cache.

  Built against the flake's own nixpkgs rather than ours, so that its Wine layers come from
  cache.forall.systems and its build tools from cache.nixos.org instead of being compiled here.
*/
{ pkgs, inputs, ... }:

let
  affinityPkgs = import inputs.affinity-nix.inputs.nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
    overlays = [ inputs.affinity-nix.overlays.default ];
  };
in
{
  nix.settings = {
    extra-substituters = [ "https://cache.forall.systems" ];
    extra-trusted-public-keys = [
      "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
    ];
  };

  environment.systemPackages = [ affinityPkgs.affinity-v3 ];
}
