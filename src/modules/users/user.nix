{ config, pkgs, ... }:

{

  imports = [./locales/de.nix];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.nora = {
      isNormalUser = true;
      initialPassword = "passy";
      shell = pkgs.zsh;
      description = "Nora";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
      ];
      group = "nora";
    };

    groups = {
      nora = {};
    };
  };
}
