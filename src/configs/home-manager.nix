{ home-manager, ... }:

{
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
