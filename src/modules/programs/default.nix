{ ... }:

{
  imports =
    [
      ./firefox.nix
      ./misc.nix
      ./steam.nix
      ./threema.nix
      # ./chromium.nix # installed via system package
    ];

}
