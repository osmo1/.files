{ inputs, pkgs, ... }:
{
  home-manager.users.osmo = {
    imports = [
      inputs.nixcord.homeModules.nixcord
    ];
    programs.nixcord = {
      enable = true;
      discord = {
        enable = true;
        package = pkgs.stable.discord;
      };
      vesktop.enable = true;
      config = {
        enabledThemes = [
          "stylix.theme.css"
        ];
        plugins = {
          ignoreActivities = {
            enable = true;
            ignorePlaying = true;
            ignoreWatching = true;
          };
          betterFolders.enable = true;
          betterRoleContext.enable = true;
          betterRoleDot.enable = true;
          betterSettings.enable = true;
          callTimer.enable = true;
          decor.enable = true;
          fakeNitro.enable = true;
          gameActivityToggle.enable = true;
          petpet.enable = true;
          secretRingToneEnabler.enable = true;
          voiceChatDoubleClick.enable = true;
          volumeBooster.enable = true;
        };
      };
    };
  };
}
