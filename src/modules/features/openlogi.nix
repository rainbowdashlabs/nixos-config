{ inputs, ... }:

{
  imports = [ inputs.openlogi.nixosModules.default ];

  programs.openlogi.enable = true;
}
