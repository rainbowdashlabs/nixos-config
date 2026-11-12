/**
  Boot loader and hardware clock.

  The hardware clock holds local time because the machines dual boot with Windows. systemd
  converts it to UTC once, in the first PID 1 it runs, which is the systemd initrd. The initrd
  therefore carries /etc/adjtime and /etc/localtime, without which it would read the clock as UTC
  and the system would run ahead by the UTC offset until NTP corrects it.
*/
{ config, pkgs, ... }:

{
  imports = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.hardwareClockInLocalTime = true;

  boot.initrd.systemd.contents = {
    "/etc/adjtime".text = config.environment.etc.adjtime.text;
    "/etc/localtime".source = "${pkgs.tzdata}/share/zoneinfo/${config.time.timeZone}";
  };
}
