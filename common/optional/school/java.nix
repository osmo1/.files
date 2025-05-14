{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.stable; [
    jdk8_headless
  ];
  home-manager.users.osmo =
    { pkgs, ... }:
    {
      programs.helix.languages.language = [
      ];
    };
}
