{ ... }:

{
  programs.git = {
    enable = true;

    signing = {
      key = null; # Let gpg decide
      signByDefault = true;
    };

    userName = "Nora";
    userEmail = "46890129+RainbowDashLabs@users.noreply.github.com";

    extraConfig = {
      core = {
        editor = "nano";
        autocrlf = "input";
      };

      checkout = {
        defaultRemote = "true";
      };

      pull = {
        rebase = true;
      };

      push = {
        default = "current";
        autosetupremote = true;
      };

      init = {
        defaultbranch = "main";
      };
    };
  };
}
