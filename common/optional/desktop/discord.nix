{
  home-manager.users.osmo =
    { inputs, ... }:
    {
      imports = [
        inputs.nixcord.homeManagerModules.nixcord
      ];
      programs.nixcord = {
        enable = true;
        discord.enable = false;
        vesktop.enable = true;
        config = {
          themeLinks = [ 
              "https://raw.githubusercontent.com/Dyzean/Tokyo-Night/main/themes/tokyo-night.theme.css"
          ];
          frameless = true;
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
