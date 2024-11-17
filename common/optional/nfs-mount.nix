{
  fileSystems."/mnt/media" = {
    device = "192.168.11.200:/media";
    fsType = "nfs";
  };
  services.cachefilesd = {
      enable = true;
  };
}
