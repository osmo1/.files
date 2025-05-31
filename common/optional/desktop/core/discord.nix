{
  home-manager.users.osmo =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.nixcord.homeManagerModules.nixcord
      ];
      programs.nixcord = {
        enable = true;
        discord = {
          enable = false;
          package = pkgs.unstable.discord;
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
