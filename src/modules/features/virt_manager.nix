{ config, pkgs, ... }:

{
#   virtualisation= {
#     virtualbox = {
#       host = {
#         enable = true;
#         enableExtensionPack = true;
#         };
#       guest = {
#         enable = true;
#         #x11 = true;
#       };
#     };
#   };
#   users.extraGroups.vboxusers.members = [ "lilly" ];

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
}
