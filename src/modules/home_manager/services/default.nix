{ ... }:

{
  imports = [
    ./flameshot.nix
    # Nextcloud installed via system package instead
    # ./nextcloud.nix
    ./misc.nix
    ./audio.nix
  ];
}
