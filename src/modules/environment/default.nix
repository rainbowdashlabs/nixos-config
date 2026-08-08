{ config, pkgs, ... }:

let
  unstablePkgs = import <nixos-unstable> { config.allowUnfree = true; };

  # JetBrains UI fix: run the IDEs on JBR 25 (JCEF) with system fontconfig.
  # Ported from https://github.com/TheZexquex/NixConfig (jbrFixOverlay).
  jetbrainsJdkPatched = unstablePkgs.stdenv.mkDerivation rec {
    pname = "jetbrains-jdk-bin";
    version = "25.0.3-linux-x64-b329.124";

    src = unstablePkgs.fetchurl {
      url = "https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-${version}.tar.gz";
      hash = "sha256-0qUPSN+zV39BTp/A7OgOIEhs6hewqZwXxZUXXzE053U=";
    };

    nativeBuildInputs = with unstablePkgs; [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = with unstablePkgs; [
      libx11
      libxext
      libxrender
      libxtst
      libglvnd
      alsa-lib
      fontconfig
      freetype
      glib
      zlib
      libXcomposite
      libXdamage
      libXfixes
      libXrandr
      libXcursor
      nss
      nspr
      dbus
      atk
      at-spi2-atk
      cups
      pango
      cairo
      libdrm
      libxkbcommon
      wayland
      mesa
    ];

    runtimeDependencies = with unstablePkgs; [
      udev
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };

  # envVarPrefix must match the IDE's launcher variable (IDEA_JDK, PYCHARM_JDK, ...)
  jbUiFix = envVarPrefix: ide:
    unstablePkgs.symlinkJoin {
      name = "${ide.name}-jbr25-patched";
      paths = [ ide ];
      nativeBuildInputs = [ unstablePkgs.makeWrapper ];
      postBuild = ''
        for exe in $out/bin/*; do
          if [ -e "$exe" ]; then
            wrapProgram "$exe" \
              --set ${envVarPrefix}_JDK "${jetbrainsJdkPatched}" \
              --set FONTCONFIG_FILE "/etc/fonts/fonts.conf" \
              --set FONTCONFIG_PATH "/etc/fonts" \
              --prefix LD_LIBRARY_PATH : "${unstablePkgs.lib.makeLibraryPath (with unstablePkgs; [ fontconfig freetype ])}"
          fi
        done
      '';
    };
in
{
  imports = [ ];

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
        fastfetch
        kdePackages.yakuake # terminal
        kdePackages.kcalc
        btop
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
        pipenv
        poetry
        git-lfs
        lazygit
        gh
        # communication
        thunderbird
        discord-ptb
        element-desktop
        slack
        signal-desktop
        # media
        spotify
        youtube-music
        flameshot
        mpv
        vlc
        blender
        #libreoffice
        onlyoffice-desktopeditors
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
        anydesk
      ]) ++
      (with unstablePkgs; [
        (jbUiFix "IDEA" jetbrains.idea)
        (jbUiFix "DATAGRIP" jetbrains.datagrip)
        (jbUiFix "WEBSTORM" jetbrains.webstorm)
        (jbUiFix "PYCHARM" jetbrains.pycharm)
        discord
        claude-code
        # emulation
        ##wineWowPackages.stable
        #winetricks
        #wineWowPackages.waylandFull
        #corefonts
      ]);
    pathsToLink = [ "/share/zsh" ];


  };
  # Additional setting for android studio
  #androidenv.accept_license = true;
}
