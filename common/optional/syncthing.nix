{
  config,
  pkgs,
  lib,
  ...
}:
let
  syncFolder = (
    if config.hostSpec.isServer == false then "/home/osmo/Documents/synced" else "/home/osmo/syncthing"
  );
in
{
  services.syncthing = {
    enable = true;
    user = "osmo";
    group = "users";
    dataDir = syncFolder;
    overrideFolders = false;
    settings = {
      gui = {
        theme = "dark";
        password = "$2a$12$SY2JgXaeQV1GkxdjmdSRbOTIqmX/mfrlNk1zRDXcw3W9DsHQGGnUy";
        user = "osmo";
      }
      // (
        if config.hostSpec.isServer == false then { apikey = "vL9oVF5sHQXxveNqvKLUzft6QSufPMZr"; } else { }
      );
      options.localAnnounceEnabled = true;
      folders = {
        "${syncFolder}/koulu" = {
          id = "koulu";
          devices = [
            "serveri"
            "kanny"
            "koulu-kone"
            "masiina"
          ];
          label = "koulu";
        };
      };
      devices = {
        masiina.id = "HJ2ZJAJ-PZEIBRO-X4OBUPJ-KNCZG74-E64UE2D-6SI5VPI-SMW2ZYV-L4GHCAD";
        kanny.id = "IJBYDHY-PDA2IAA-WODJAAK-BJ32BOD-MX2WFU5-23ELJ5B-T4J5UUO-QBYE6QB";
        serveri.id = "QKL76IT-JCH32JW-D4EUCYL-3EY2ILY-T6LWDXC-W4HHPM4-KH4J5WU-LG666QY";
        koulu-kone.id = "HAXX6CR-APH3FMS-K6XIJ7-ZCMSN6R-GBV6T6X-NHWETSU-TVQ6M4T-MSYBIWB";
        # HAXX6CR-APH3FMS-LK6XIJ7-ZCMSN6E-GBV6T6X-NHWETSU-TVQ6M4T-MSYBIQB
        lixos.id = "ZTVLUCL-3TWLMSG-XVJEG3S-IU4BQXI-FN5745F-67ZSDBB-IM75NL7-MZMTFA6";
      };
      /*
        "${syncFolder}/koulu" = {
          id = "home";
          devices = [
            "serveri"
            "kanny"
            "lixos"
            "masiina"
          ];
        };
      */
    };
  }
  // (if config.hostSpec.isServer == true then { guiAddress = "192.168.11.10:8384"; } else { });

  networking.firewall = {
    allowedTCPPorts = [
      22000
    ]
    ++ (lib.mkOptional config.hostSpec.isServer [ 8384 ]);
    allowedUDPPorts = [
      22000
      21027
    ];
  };
  users.users.osmo.packages = (
    if config.hostSpec.isServer == false then [ pkgs.syncthingtray ] else [ ]
  );
  systemd.tmpfiles.rules = [
    "d ${syncFolder} 0770 osmo users - -"
  ];
  home-manager.users = (
    if config.hostSpec.isServer == true then
      let
        traefikConf =
          { config, lib, ... }:
          {
            home.activation.syncthing-file =
              let
                nconfig = ''
                  http:
                    routers:
                      syncthing:
                        rule: "Host(\`syncthing.klusteri-0.serweri.zip\`)"
                        entryPoints:
                          - websecure
                        tls:
                          certResolver: porkbun
                        service: syncthing
                    services:
                      syncthing:
                        loadBalancer:
                          servers:
                            - url: http://192.168.11.10:8384
                '';
              in
              config.lib.dag.entryAfter [ "writeBoundary" ] ''
                cat <<EOF > /home/osmo/traefik/config/syncthing.yaml
                ${nconfig}
                EOF
              '';
          };
      in
      {
        osmo = traefikConf;
      }
    else
      { }
  );
}
