{ ... }:

{
  programs.git = {
    enable = true;

    signing = {
      key = null; # Let gpg decide
      signByDefault = true;
    };


    settings = {
      user = {
        name = "Nora";
        email = "46890129+RainbowDashLabs@users.noreply.github.com";
      };

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

    includes = [
      {
        condition = "gitdir:~/dev/work/";
        contents.user = {
          email = (builtins.readFile /etc/nixos/assets/git/work/mail);
          name = (builtins.readFile /etc/nixos/assets/git/work/name);
        };
      }
    ];
  };
}
