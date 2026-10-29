{ ... }:

{
  imports = [ ../../../../nix-assets/home.nix ];

  # Maintained by ./build, which links it to wherever this repository is checked out.
  assets.checkout = "/etc/nixos/checkout/nix-assets";

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
