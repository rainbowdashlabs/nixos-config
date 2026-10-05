{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = ["de" "en-GB"];
  };
}
