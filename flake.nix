{
  description = "NixOS configuration for shepard, liara and horizon";

  inputs = {
    self.submodules = true;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openlogi = {
      url = "github:AprilNEA/OpenLogi";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      host =
        name:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./src/hosts/${name}.nix ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs [
        "shepard"
        "liara"
        "horizon"
      ] host;

      packages.x86_64-linux.threema-desktop = import ./src/packages/threema-desktop {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}
