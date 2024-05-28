{ config, pkgs, ... }:

{
  programs = {
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["lilly"];
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
  };
}
