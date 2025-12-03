{ pkgs, ... }:
{
  users.users.osmo.packages =
    (with pkgs.stable; [
      luanti
      heroic
      mangohud
      lutris-free
      prismlauncher
      atlauncher
    ])
    ++ (with pkgs.unstable; [
      nexusmods-app-unfree
      protontricks
      (glfw3.override { withMinecraftPatch = true; }) # Still needed?
    ]);

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  environment.variables = {
    WINEDLLOVERRIDES = "winmm,version=n,b;dxgi=n,b";
  };

  # Fuck the combination of nexusmods and star citizen, nexusmods expects a games folder in the user home and star citizen expects Games.
  fileSystems."/home/osmo/games" = {
    device = "/home/osmo/Games";
    options = [ "bind" ];
  };
}
