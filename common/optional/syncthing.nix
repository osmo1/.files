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
      gui =
        {
          theme = "dark";
          password = "$2a$12$SY2JgXaeQV1GkxdjmdSRbOTIqmX/mfrlNk1zRDXcw3W9DsHQGGnUy";
          user = "osmo";
        }
        // (
          if config.hostSpec.isServer == false then { apikey = "vL9oVF5sHQXxveNqvKLUzft6QSufPMZr"; } else { }
        );
      folders = {
        "${syncFolder}/koulu" = {
          id = "koulu";
          devices = [
            "serveri"
            "kanny"
            #"lixos"
            "masiina"
          ];
          label = "koulu";
        };
      };
      devices = {
        masiina.id = "HJ2ZJAJ-PZEIBRO-X4OBUPJ-KNCZG74-E64UE2D-6SI5VPI-SMW2ZYV-L4GHCAD";
        kanny.id = "KUABWRX-SKPHZ4Y-DVOLV74-X3EQQCZ-733DD6M-4XUJCML-UMLUO4M-W6JSHAQ";
        serveri.id = "QKL76IT-JCH32JW-D4EUCYL-3EY2ILY-T6LWDXC-W4HHPM4-KH4J5WU-LG666QY";
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
  } // (if config.hostSpec.isServer == true then { guiAddress = "192.168.11.10:8384"; } else { });

  networking.firewall.allowedTCPPorts = [ 8384 ];
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
                        rule: "Host(\`syncthing.klusteri-0.kotiserweri.zip\`)"
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
