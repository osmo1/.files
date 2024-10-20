{ pkgs, ... }: {
  hardware.bluetooth.enable = true;
  users.users.osmo.packages = with pkgs; [ bluetuith ];
}
