{ ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
    config = {
      global = {
        disable_stdin = true;
        warn_timeout = "5m";
      };
    };
  };
}
