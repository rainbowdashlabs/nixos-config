{ pkgs }:
pkgs.writeShellApplication {
  name = "git-place";
  runtimeInputs = with pkgs; [
    git
    fzf
    coreutils
    findutils
    gnused
  ];
  text = builtins.readFile ./git-place.sh;
}
