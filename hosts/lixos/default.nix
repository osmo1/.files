{
  configLib,
  ...
}:
let
  hostnames = [
    "masiina"
    "serveri"
    "klusteri-0"
    "klusteri-1"
    "klusteri-2"
  ];
in
{
  imports = (configLib.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/desktop/plasma
    ../../common/optional/grub.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/ssh.nix
    ../../common/optional/sddm.nix
  ];

  system.stateVersion = "24.05";

  # TODO: Where to put this?
  sops.secrets = builtins.listToAttrs (
    map (hostname: {
      name = "nixos/${hostname}/ssh/private";
      value = {
        path = "/home/osmo/.ssh/${hostname}";
        owner = "osmo";
        group = "users";
        mode = "600";
      };
    }) hostnames
  );

  networking.hostName = "lixos";
}
