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

    # The CLI has to come from this module rather than environment.systemPackages. It installs op
    # behind a setgid wrapper at /run/wrappers/bin/op, and the desktop app verifies the calling
    # binary before it will talk to it — an unwrapped op is refused with "connecting to desktop
    # app: read: connection reset", which reads as though the integration setting were off.
    _1password.enable = true;

    _1password-gui = {
      enable = true;
      # Was "lilly", who does not exist on this system or anywhere in this configuration — left
      # behind by the username migration. The owner has to be a real user or nothing is added to
      # the onepassword group.
      polkitPolicyOwners = [ "nora" ];
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
