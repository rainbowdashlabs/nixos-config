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

      alias = {
        cb = "!git fetch -p && for branch in $(git for-each-ref --format '\''%(refname) %(upstream:track)'\'' refs/heads | awk '\''$2 == \"[gone]\" {sub(\"refs/heads/\", \"\", $1); print $1}'\''); do git branch -D $branch; done";
        trigger = "!git commit -m \"Trigger\" --allow-empty";
        pfusch = "!git push --force-with-lease";
        cc = "!f(){ br=$(git rev-parse --abbrev-ref HEAD); msg=\"$*\"; case \"$br\" in feature/*) key=\${br#feature/}; key=\${key%%/*}; msg=\"$key $msg\";; esac; git commit -m \"$msg\"; }; f";
      };
    };

    includes = [
      {
        condition = "gitdir:~/dev/work/";
        contents = {
          user = {
            email = (builtins.readFile /etc/nixos/assets/git/work/mail);
            name = (builtins.readFile /etc/nixos/assets/git/work/name);
          };
        };
      }
    ];
  };
}
