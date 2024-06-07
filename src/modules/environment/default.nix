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
#      kate
      typora
      docker-compose
      libgcc
      wireguard-tools
      # python
      pipenv
      poetry
      # Nix really doesnt like multiple python versions. This produces just a big clusterfuck
#      # python39 # error for some reason idc
#      python310
#      python310Packages.cython
#      python311
#      python311Packages.cython
#      python311Packages
#      python312
#      python313
      # communication
      thunderbird
      discord
      discord-canary
      slack
      # media
      obs-studio
      spotify
      flameshot
      mpv
      vlc
      chromium
      onlyoffice-bin
      nextcloud-client
      #libsForQt5.gwenview
      # games
      prismlauncher
      # tooling
      clinfo
      vulkan-tools
      gpu-viewer
      pciutils
      coreutils-full
      gparted
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
