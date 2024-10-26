{
  pkgs,
  inputs,
  configLib,
  ...
}:
let
  hostnames = [
    "testeri"
    "serveri"
    "klusteri-0"
    "klusteri-1"
  ]; # Add your hostnames here
in
{
  imports = (configLib.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/plasma
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

  #TODO: Find a better place for this
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      /*
        theme = "rings";
        	    themePackages = with pkgs; [
        		(adi1090x-plymouth-themes.override {
        		  selected_themes = [ "rings" ];
        		})
        	    ];
      */
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader.timeout = 0;
  };

  networking.hostName = "lixos";

}
