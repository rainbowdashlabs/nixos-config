{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.lilly = {
      isNormalUser = true;
      initialPassword = "passy";
      shell = pkgs.zsh;
      description = "Lilly";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
      ];
      group = "lilly";
    };

    groups = {
      lilly = {};
    };
  };
}
