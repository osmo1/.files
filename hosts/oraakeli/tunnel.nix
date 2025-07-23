{
  # This is a default tunnel to access the vps' network
  virtualisation.oci-containers = {
    containers.wireguard = {
      hostname = "wireguard";
      image = "lscr.io/linuxserver/wireguard:latest";
      volumes = [
        "/home/osmo/wireguard:/config"
        "/etc/resolv.conf:/etc/resol.conf:ro"
      ];
      ports = [
        "51820:51820/udp"
        "51821:51821"
      ];
      environment = {
        PGUID = "1000";
        PGID = "100";
        TZ = "Europe/Helsinki";
        PEERS = "4";
      };
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--privileged"
        # "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
        "--sysctl=net.ipv4.ip_forward=1"
        # "--sysctl=net.ipv4.conf.all.rp_filter=2"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 51821 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
}
