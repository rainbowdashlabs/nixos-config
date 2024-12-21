{ config, pkgs, ... }:

let
  unstablePkgs = import <nixos-unstable> { config.allowUnfree = true; };
in
{
  imports = [];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {

    # Some wayland enforcer shit
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SDL_VIDEODRIVER = "wayland";
    };

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
      kate
#      kate
      gnumake
      typora
      docker-compose
      libgcc
      wireguard-tools
      wgnord
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
      discord-ptb
      slack
      # media
      obs-studio
      spotify
      youtube-music
      flameshot
      mpv
      vlc
      chromium
      libsForQt5.gwenview
      #libreoffice
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
      anydesk
    ]) ++
    (with unstablePkgs; [
      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.webstorm
      jetbrains.pycharm-professional
      discord
      jetbrains.webstorm
    ]);
    pathsToLink = [ "/share/zsh" ];


  };
  # Additional setting for android studio
  #androidenv.accept_license = true;
}
