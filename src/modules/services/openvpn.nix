{ config, ... }:

{
  services.openvpn = {
    servers = {
      work = {
        config = "config /etc/nixos/assets/openvpn/work.ovpn";
      };
    };
  };
}
