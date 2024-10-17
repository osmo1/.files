{ inputs, outputs, lib, pkgs, configLib, ... }: {
  imports = (configLib.scanPaths ./.)
    ++ [ inputs.home-manager.nixosModules.home-manager ];
    #++ (builtins.attrValues outputs.nixosModules);
  

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    # Defaults env_keep + =SSH_AUTH_SOCK
  '';

  home-manager.extraSpecialArgs = { 
  	inherit inputs outputs;
  	plasma-manager = inputs.plasma-manager;
  };
  
  time.timeZone = lib.mkDefault "Europe/Helsinki";

  i18n.defaultLocale = lib.mkDefault "en_IE.UTF-8";

  environment.sessionVariables = {
      FLAKE = "/home/osmo/.files";
  };

  console.keyMap = "fi";

  # Enable networking
  networking.networkmanager.enable = true;
  nixpkgs = {
    #overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  networking.firewall.enable = true;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  #hardware.enableRedistributableFirmware = true;
}
