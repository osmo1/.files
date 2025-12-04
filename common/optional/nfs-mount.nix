{
  fileSystems."/mnt/media" = {
    device = "192.168.11.200:/media";
    fsType = "nfs";
    options = [
      "rw"
      "sync"
      "vers=4.2"
      "rsize=32768"
      "wsize=32768"
    ];
  };
  boot.supportedFilesystems = [ "nfs" ];
  services.cachefilesd = {
    enable = true;
  };
}
