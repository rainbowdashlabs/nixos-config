{ config, ... }:

{
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
}
