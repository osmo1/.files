{ configLib, pkgs, ... }:
{
  imports = (configLib.scanPaths ./.)
  	++ [ ../sound.nix ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
  	enable = true;
	wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
        layout = "fi";
    	variant = "winkeys";
    };
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
  ];

}
