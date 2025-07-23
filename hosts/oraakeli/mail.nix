{
  virtualisation.oci-containers = {
    containers.mail = {
      image = "docker.io/mailserver/docker-mailserver:13.3.1";
      #user = "osmo:x";
      volumes = [
        "/home/osmo/marqify/data:/var/mail"
        "/home/osmo/marqify/state:/var/mail-state"
        "/home/osmo/marqify/logs:/var/log/mail"
        "/home/osmo/marqify/config:/tmp/docker-mailserver"
        "/home/osmo/marqify/misc/10-master.conf:/etc/dovecot/conf.d/10-master.conf"
        "/home/osmo/marqify/misc/master.cf:/etc/postfix/master.cf"
        #"/home/osmo/marqify/aliases:/etc/aliases"
        #"/home/osmo/marqify/aliases.db:/etc/aliases.db"
        "/home/osmo/marqify/certs/:/etc/certs/"
        "/etc/localtime:/etc/localtime:ro"
      ];
      ports = [
        "25:25"
        "465:465"
        "587:587"
        "993:993"
        "110:110"
        "143:143"
      ];
      environmentFiles = [ /home/osmo/imp/mail.env ];
      extraOptions = [
        "--cap-add=NET_ADMIN"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [
    25
    110
    143
    465
    587
    993
  ];
}
