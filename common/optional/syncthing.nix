{ config, pkgs, ... }:
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
        apikey = "vL9oVF5sHQXxveNqvKLUzft6QSufPMZr";
      };
      natEnabled = false;
      folders = {
        "${syncFolder}/koulu" = {
          id = "koulu";
          devices = [
            #"serveri"
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
  };

  #networking.firewall.allowedTCPPorts = [ 8384 ];
  users.users.osmo.packages = (
    if config.hostSpec.isServer == false then [ pkgs.syncthingtray ] else [ ]
  );
  systemd.tmpfiles.rules = [
    "d ${syncFolder} 0770 osmo users - -"
  ];
}
