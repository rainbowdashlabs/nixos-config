{ config, pkgs, ... }:

let
  unstablePkgs = import <nixos-unstable> { config.allowUnfree = true; };
in
{
  imports = [];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages =
    (with pkgs; [
      # basics
      neofetch
      libsForQt5.yakuake # terminal
      # cli tools
      bash
      less
      bat
      tldr
      wget
      # development
      pipenv
      kate
      docker-compose
      # communication
      thunderbird
      discord
      discord-canary
      slack
      # media
      spotify
      flameshot
      mpv
      vlc
      chromium
      # tooling
      clinfo
      vulkan-tools
      gpu-viewer
      pciutils
    ]) ++
    (with unstablePkgs; [
      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.pycharm-professional
    ]);
    pathsToLink = [ "/share/zsh" ];
  };
}
