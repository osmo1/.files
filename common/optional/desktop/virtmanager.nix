{
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    home-manager.users.osmo = {
        dconf.settings = {
              "org/virt-manager/virt-manager/connections" = {
                autoconnect = ["qemu:///system"];
                uris = ["qemu:///system"];
              };
            };
    };
    networking = {
      bridges.br0.interfaces = [ "enp42s0" ]; 
#interfaces.br0.up = true;

#useDHCP = true;
      dhcpcd.denyInterfaces = [ "enp42s0" ];  
    };
}
