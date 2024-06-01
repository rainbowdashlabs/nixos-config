{ ... }:

{
  imports =
    [ # Include the results of the hosts.hardware scan.
      ./src/modules
    ];

  networking.hostName = "nixos";
}
