{ inputs, ... }:
{
  home-manager.users.osmo =
    { inputs, pkgs, ... }:
    {
      home.stateVersion = "24.05";
    };
}