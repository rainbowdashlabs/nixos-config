{ ... }:

{
  imports =
    [
      <home-manager/nixos>
    ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.lilly = {
      imports = [
        ./base
        ./programs
        ./services
      ];
    };
  };
}
