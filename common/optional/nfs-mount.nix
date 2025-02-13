{
  fileSystems."/mnt/media" = {
    device = "192.168.11.200:/home/osmo/data/nfs/media";
    fsType = "nfs";
#options = [ "rw" "sync" "vers=4.2" "rsize=32768" "wsize=32768" ];
  };
  services.cachefilesd = {
    enable = true;
  };
}
