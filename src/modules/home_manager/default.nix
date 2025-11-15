{ ... }:

{
  imports =
    [
      <home-manager/nixos>
    ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.nora = {
      imports = [
        ./base
        ./programs
        ./services
      ];
    };
  };
}
