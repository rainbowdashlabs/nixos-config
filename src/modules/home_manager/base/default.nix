{ config, ... }:

{
  imports = [ ../../../../nix-assets/home.nix ];

  assets.checkout = "${config.home.homeDirectory}/dev/nixos-config/nix-assets";

  home = {
    username = "nora";
    homeDirectory = "/home/nora";

    stateVersion = "23.11";

    file.".ssh/config" = {
        source = ../../../../nix-assets/ssh/config;
        force = true;
    };
  };
}
