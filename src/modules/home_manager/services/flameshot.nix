{ ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath="~/Pictures/flameshot/";
      };
    };
  };
}
