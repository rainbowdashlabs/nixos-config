# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "liara"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = ["all"];
    # Select internationalisation properties.
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # Configure keymap in X11
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    displayManager = {
      sddm.enable = true;
    };
    # Enable the KDE Plasma Desktop Environment.
    desktopManager = {
      plasma5.enable = true;
    };

    xkb = {
      layout = "de,uk-swapped";
      variant = "";
      extraLayouts = {
        uk-swapped = {
          description = "Custom UK layout with z and y swapped";
          languages = ["eng"];
          symbolsFile = /etc/nixos/assets/gb;
        };
      };
    };
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lilly = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Lilly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      thunderbird
    ];
  };

  home-manager.users.lilly = {
    home.stateVersion = "23.11";

    gtk = {
      enable = true;
      theme = {
        name = "Breeze-Dark";
        package = pkgs.libsForQt5.breeze-gtk;
      };
    };

    programs = {
      zsh = {
        enable = true;

        antidote = {
          enable = true;
          plugins = [
            "zsh-users/zsh-autosuggestions"
            "zsh-users/zsh-completions"
          ];
          useFriendlyNames = true;
        };

        autocd = true;

        # autosuggestion.enable = true;

        history = {
          expireDuplicatesFirst = true;
        };

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
        initExtra = "export GPG_TTY=$(tty)\ngpg-connect-agent updatestartuptts /bye >/dev/null";
      };

      git = {
        enable = true;

        signing = {
          key = null; # Let gpg decide
          signByDefault = true;
        };

        userName = "Lilly";
        userEmail = "46890129+RainbowDashLabs@users.noreply.github.com";

        extraConfig = {
          core = {
            editor = "nano";
            autocrlf = "input";
          };

          checkout = {
            defaultRemote = "true";
          };

          pull = {
            rebase = true;
          };

          push = {
            default = "current";
            autosetupremote = true;
          };

          init = {
            defaultbranch = "main";
          };
        };
      };

#      gradle = {
#        enable = true;
#      };

      htop = {
        enable = true;
        settings = {

        };
      };

      java = {
        enable = true;
      };

      pyenv = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    services = {
      flameshot = {
        enable = true;
        settings = {
          General = {
            savePath="~/Pictures/flameshot";
          };
        };
      };
      nextcloud-client = {
        enable = true;
        startInBackground = true;
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.pycharm-professional
      discord
      discord-canary
      libsForQt5.yakuake
      bat
      spotify
      slack
      docker-compose
      tldr
      flameshot
      neofetch
      wget
      less
      mpv
      vlc
      pipenv
    ];
    pathsToLink = [ "/share/zsh" ];
  };

  programs = {
    _1password-gui.enable = true;
    zsh.enable = true;
    kdeconnect.enable = true;
    git.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryFlavour = "gtk2";
    };
    dconf.enable = true;
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
