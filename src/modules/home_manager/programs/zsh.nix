{ pkgs, ... }:

{
  programs.zsh = {
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
    initContent = "export GPG_TTY=$(tty)\ngpg-connect-agent updatestartuptts /bye >/dev/null";
  };
}
