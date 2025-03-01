{
  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };
  services.nfs.server = {
    enable = true;
    exports = ''
      /home/osmo/data/nfs        192.168.11.10(rw,fsid=0,no_subtree_check) 192.168.11.11(rw,fsid=0,no_subtree_check) 192.168.11.245(rw,fsid=0,no_subtree_check)
      /home/osmo/data/nfs/media  192.168.11.10(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 192.168.11.11(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 192.168.11.245(rw,nohide,insecure,no_subtree_check,async,no_root_squash)
    '';
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
  };
}
