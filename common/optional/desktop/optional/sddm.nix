{ config, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = (
      if config.services.displayManager.sddm.settings.General.DefaultSession == "dwl.desktop" then
        "sddm-tokyonight"
      else
        ""
    );
  };
}
