{
  pkgs,
  inputs,
  configLib,
  ...
}:
let
  hostnames = [
    "masiina"
    "testeri"
    "serveri"
    "klusteri-0"
    "klusteri-1"
  ]; # Add your hostnames here
in
{
  imports = (configLib.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/dwl
    ../../common/optional/systemd-boot.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/impermanence.nix
    ../../common/optional/tpm.nix
    ../../common/optional/ssh.nix
    ../../common/optional/gaming.nix
    ../../common/optional/sddm.nix
    #../../common/optional/auto-login.nix
  ];

  system.stateVersion = "24.05";

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

  boot.loader.timeout = 0;

  networking.hostName = "lixos";

}
