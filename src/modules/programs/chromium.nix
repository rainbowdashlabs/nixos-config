{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    extensions = [
      "bfogiafebfohielmmehodmfbbebbbpei"
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa"
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    ];
  };
}
