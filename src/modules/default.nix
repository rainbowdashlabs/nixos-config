{ config, pkgs, ... }:

{
  imports =
    [
      ./home_manager
      ./features
      ./programs
      ./users
      ./services
      ./environment
      ./boot
    ];
}
