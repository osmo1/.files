{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  home-manager.users.osmo = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
