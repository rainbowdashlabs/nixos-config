{ ... }:

{
  programs = {

#    gradle = {
#      enable = true;
#    };

    htop = {
      enable = true;
      settings = {

      };
    };

#    java = {
#      enable = true;
#    };

    pyenv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
