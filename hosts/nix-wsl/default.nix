{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/school
  ];

  hostSpec = {
    hostName = "nix-wsl";

    sshKeys = [
      "testeri"
      "serveri"
      "klusteri-0"
      "klusteri-1"
      "klusteri-2"
    ];
  };

  wsl.enable = true;
  wsl.defaultUser = "osmo";
}
