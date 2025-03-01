{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        ControllerMode = "dual";
      };
    };
  };
  users.users.osmo.packages = with pkgs; [ bluetuith ];
}
