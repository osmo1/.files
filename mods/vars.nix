{ lib, ... }:
{
  networking = import ./networking.nix { inherit lib; };

  username = "osmo";
  #domain = inputs.nix-secrets.domain;
  #userFullName = inputs.nix-secrets.full-name;
  handle = "osmo1";
  #userEmail = inputs.nix-secrets.user-email;
  gitHubEmail = "45790171+osmo1@users.noreply.github.com";
  codebergEmail = "osmo1@noreply.codeberg.org";
  #workEmail = inputs.nix-secrets.work-email;
  persistFolder = "/persist";
  isMinimal = false; # Used to indicate nixos-installer build
}
