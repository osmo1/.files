{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
  global = {
    workgroup = "WORKGROUP";
    "server role" = "standalone server";
    "dns proxy" = "no";

    "pam password change" = "yes";
    "map to guest" = "bad user";
    "usershare allow guests" = "yes";
    "create mask" = "0664";
    "force create mode" = "0664";
    "directory mask" = "0775";
    "force directory mode" = "0775";
    "follow symlinks" = "yes";
    "load printers" = "no";
    printing = "bsd";
    "printcap name" = "/dev/null";
    "disable spoolss" = "yes";
    "strict locking" = "no";
    "inherit permissions" = "yes";

    # Security
    "client ipc max protocol" = "SMB3";
    "client ipc min protocol" = "SMB2_10";
    "client max protocol" = "SMB3";
    "client min protocol" = "SMB2_10";
    "server max protocol" = "SMB3";
    "server min protocol" = "SMB2_10";

    # Performance
    "socket options" = "TCP_NODELAY SO_SNDBUF=131072 SO_RCVBUF=131072";
    "use sendfile" = "yes";
    "min receivefile size" = "16384";
    "aio read size" = "16384";
    "aio write size" = "16384";
  };
  };
    shares = {
      osmon-samba = {
        path = "/home/osmo/data/samba/";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "osmo";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
    systemd.tmpfiles.rules = [
      "d /home/osmo/data/samba 0750 osmo users - -"
    ];
}
