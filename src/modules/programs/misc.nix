{ config, pkgs, ... }:
let
  unstablePkgs = import <nixos-unstable> { config.allowUnfree = true; config.cudaSupport = true; };
in
{
  programs = {
    obs-studio = {
      enable = true;
      package = unstablePkgs.obs-studio;

      plugins = with unstablePkgs.obs-studio-plugins; [
        obs-aitum-multistream
      ];
    };

    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "lilly" ];
      package = unstablePkgs._1password-gui;
    };
    zsh = {
      enable = true;
      #      ohMyZsh.plugins = [
      #        {
      #          name = "zsh-autosuggestions";
      #          src = pkgs.zsh-autosuggestions;
      #        }
      #        {
      #          name = "zsh-completions";
      #          src = pkgs.zsh-completions;
      #        }
      #      ];
    };
    kdeconnect.enable = true;
    git.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavour = "gtk2";
    };
    dconf.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        R
      ];
    };
  };
}
