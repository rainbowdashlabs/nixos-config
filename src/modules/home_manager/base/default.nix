{ config, ... }:

{
  home = {
    username = "nora";
    homeDirectory = "/home/nora";

    stateVersion = "23.11";

    file.".ssh/config" = {
        source = "/etc/nixos/assets/ssh/config";
        force = true;
    };
  };
}
