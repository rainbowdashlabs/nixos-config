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
      libsForQt5.kcalc
      # cli tools
      bash
      less
      bat
      tldr
      wget
      # development
      pipenv
      kate
      typora
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
      onlyoffice-bin
      nextcloud-client
      libsForQt5.gwenview
      # games
      prismlauncher
      # tooling
      clinfo
      vulkan-tools
      gpu-viewer
      pciutils
      toybox
      # bootloading
      refind
      efibootmgr
      # java
      (gradle.overrideAttrs {
        javaToolchains = with pkgs; [ jdk11 jdk17 jdk21 ];
      })
      whatsapp-for-linux
    ]) ++
    (with unstablePkgs; [
      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.pycharm-professional
    ]);
    pathsToLink = [ "/share/zsh" ];
  };
}
