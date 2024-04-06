{ config, pkgs, ... }:

{
  home-manager.users.lilly = {
    home.stateVersion = "23.11";

    programs = {
      zsh = {
        enable = true;
        autocd = true;

        # autosuggestion.enable = true;

        history = {
          expireDuplicatesFirst = true;
        };

        plugins = [
          {
            name = "zsh-autosuggestions";
            src = pkgs.zsh-autosuggestions;
          }
          {
            name = "zsh-completions";
            src = pkgs.zsh-completions;
          }
        ];

        oh-my-zsh = {
          enable = true;
          plugins = [
            "zsh-autosuggestions"
            "zsh-completions"
            "gitfast"
            "git-extras"
            "gradle"
            "docker"
            "mvn"
            "python"
            "screen"
            "sublime"
            "sudo"
            "sdk"
            "pipenv"
            "rust"
            "docker-compose"
          ];
          theme = "robbyrussell";
        };
        initExtra = "export GPG_TTY=$(tty)\ngpg-connect-agent updatestartuptts /bye >/dev/null";
      };

      git = {
        enable = true;

        signing = {
          key = null; # Let gpg decide
          signByDefault = true;
        };

        userName = "Lilly";
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

#      gradle = {
#        enable = true;
#      };

      htop = {
        enable = true;
        settings = {

        };
      };

      java = {
        enable = true;
      };

      pyenv = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    services = {
      flameshot = {
        enable = true;
        settings = {
          General = {
            savePath="~/Pictures/flameshot";
          };
        };
      };
      nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };
  };
}
