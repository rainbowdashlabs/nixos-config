{ ... }:

{
  imports =
    [
      ./firefox.nix
      ./misc.nix
      ./steam.nix
      # ./chromium.nix # installed via system package
    ];

}
