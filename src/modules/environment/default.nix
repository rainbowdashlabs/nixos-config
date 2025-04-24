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
      uwuify
      fastfetch
      kdePackages.yakuake # terminal
      kdePackages.kcalc
      # cli tools
      bash
      less
      bat
      tldr
      wget
      # development
      gnumake
      typora
      docker-compose
      libgcc
      wireguard-tools
      wgnord
      pipenv
      poetry
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
      #libreoffice
      onlyoffice-bin
      nextcloud-client
      # games
      prismlauncher
      lutris
      steam
      protonup-qt
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
      (chromium.override {
        enableWideVine = true;
        commandLineArgs = [
            "--enable-features=AcceleratedVideoEncoder,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
            "--enable-features=VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
            "--enable-features=UseMultiPlaneFormatForHardwareVideo"
            "--enable-features=AcceleratedVideoEncoder"
            "--ignore-gpu-blocklist"
            "--enable-zero-copy"
        ];
       }) # enables drm protected content
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
