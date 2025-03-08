{

  ...
}:

{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/xfce
    ../../common/optional/cybersecurity.nix
  ];

  hostSpec = {
    hostName = "cbt";

    theme = "Tokyo Night";
    style = "";
  };
}
