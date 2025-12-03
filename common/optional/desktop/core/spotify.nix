{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.spicetify-nix.nixosModules.default ];
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      spotifyPackage = pkgs.unstable.spotify;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        pointer
      ];

      theme = lib.mkForce spicePkgs.themes.text;
      colorScheme = lib.mkForce (
        if config.hostSpec.theme == "Tokyo Night" then "TokyoNight" else "Kanagawa"
      );
    };
}
