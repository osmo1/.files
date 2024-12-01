{
  networking.firewall.allowedTCPPorts = [ 2049 ];
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /home/osmo/data/nfs        192.168.11.10(rw,fsid=0,no_subtree_check) 192.168.11.11(rw,fsid=0,no_subtree_check) 192.168.11.245(rw,fsid=0,no_subtree_check)
    /home/osmo/data/nfs/media  192.168.11.10(rw,nohide,insecure,no_subtree_check) 192.168.11.11(rw,nohide,insecure,no_subtree_check) 192.168.11.245(rw,nohide,insecure,no_subtree_check)
  '';
    systemd.tmpfiles.rules = [
      "d /home/osmo/data/nfs 0770 osmo users - -"
      "d /home/osmo/data/nfs/media 0770 osmo users - -"
      "d /home/osmo/data/nfs/media/tv 0770 osmo users - -"
      "d /home/osmo/data/nfs/media/movies 0770 osmo users - -"
      "d /home/osmo/data/nfs/media/downloads 0770 osmo users - -"
    ];
}
