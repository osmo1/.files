{ inputs, pkgs, ... }:
{
  users.users.osmo.packages = with pkgs.stable; [
    inputs.zen-browser.packages."${system}".default
  ];

  home-manager.users.osmo = {
    imports = [
      inputs.zen-browser.homeModules.default
    ];
    programs.zen-browser = {
      enable = true;

      profiles = {
        "Default Profile" = {
        };
      };
      policies =
        let
          mkExtensionSettings = builtins.mapAttrs (
            _: pluginId: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
              installation_mode = "force_installed";
            }
          );
        in
        {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          ExtensionSettings = mkExtensionSettings {
            "uBlock0@raymondhill.net" = "ublock-origin";
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
            "addon@darkreader.org" = "darkreader";
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
            "sponsorBlocker@ajay.app" = "sponsorblock";
            "deArrow@ajay.app" = "dearrow";
            "{a250ed19-05b9-4486-b2c3-535044766b8c}" = "hide-scrollbars";
            "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" = "user-agent-string-switcher";
          };
        };
    };
    # Not in this stylix release yet
    # stylix.targets.zen-browser = {
    #   enable = true;
    #   profileNames = [
    #     "Default Profile"
    #   ];
    # };
  };
}
