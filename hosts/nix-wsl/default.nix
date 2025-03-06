{
  
  ...
}:
let
  hostnames = [
    "testeri"
    "serveri"
    "klusteri-0"
    "klusteri-1"
    "klusteri-2"
  ];
in
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/school
  ];

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
  system.stateVersion = "24.05";

  networking.hostName = "nix-wsl";
  wsl.enable = true;
  wsl.defaultUser = "osmo";
}
