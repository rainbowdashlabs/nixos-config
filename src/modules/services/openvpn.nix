{ config, ... }:

{
  services.openvpn = {
    servers = {
      work = {
        config = "config ~/modules/assets/openvpn/work.ovpn";
      };
    };
  };
}
