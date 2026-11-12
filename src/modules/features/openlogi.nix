/**
  OpenLogi from its upstream flake.

  The package gets zstd as an extra build input: the nixpkgs-unstable cargo hook sets
  `ZSTD_SYS_USE_PKG_CONFIG`, so the workspace tests (which build xtask and with it zstd-sys)
  need libzstd through pkg-config, and the upstream package does not provide it.
*/
{ inputs, pkgs, ... }:

let
  upstream = inputs.openlogi.packages.${pkgs.stdenv.hostPlatform.system}.openlogi;
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.openlogi.nixosModules.default ];

  programs.openlogi = {
    enable = true;
    package = upstream.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ unstablePkgs.zstd ];
    });
  };
}
