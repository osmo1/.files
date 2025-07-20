{ config, lib, ... }:
let
  cursor-size = if !config.hostSpec.isLaptop == true then 24 else 12;
in
{
  home-manager.users.osmo =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.stylix.homeManagerModules.stylix ];
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme =
          if config.hostSpec.theme == "Tokyo Night" then
            {
              "base00" = "1a1b26";
              "base01" = "1f2335";
              "base02" = "292e42"; # ??
              "base03" = "414868";
              "base04" = "565f89"; # ??
              "base05" = "a9b1d6";
              "base06" = "c0c0c0";
              "base07" = "c0caf5";
              "base08" = "f7768e";
              "base09" = "ff9e64";
              "base0A" = "e0af68";
              "base0B" = "9ece6a";
              "base0C" = "7dcfff";
              "base0D" = "7aa2f7";
              "base0E" = "bb9af7";
              "base0F" = "db4b4b";
            }
          else
            {
              "base00" = "1f1f28";
              "base01" = "2a2a37";
              "base02" = "223249";
              "base03" = "727169";
              "base04" = "c8c093";
              "base05" = "dcd7ba";
              "base06" = "938aa9";
              "base07" = "363646";
              "base08" = "c34043";
              "base09" = "ffa066";
              "base0A" = "dca561";
              "base0B" = "98bb6c";
              "base0C" = "7fb4ca";
              "base0D" = "7e9cd8";
              "base0E" = "957fb8";
              "base0F" = "d27e99";
            };
        fonts = {
          monospace = {
            name = "FiraMono Nerd Font";
            package = pkgs.nerd-fonts.fira-mono;
          };
          sansSerif = {
            name = "Cantarell";
            package = pkgs.cantarell-fonts;
          };
          serif = {
            name = "Cantarell";
            package = pkgs.cantarell-fonts;
          };
          # TODO: Laptop sizes, requires testing
          sizes =
            if !config.hostSpec.isLaptop then
              {
                applications = 12;
                desktop = 10;
                popups = 10;
                terminal = 14;
              }
            else
              { };
        };
        cursor = {
          name = "capitaine-cursors";
          package = pkgs.capitaine-cursors;
          size = cursor-size;
        };
        opacity = {
          desktop = 1;
          applications = 0.9;
          popups = 0.8;
          terminal = 0.9;
        };
        polarity = "dark";
        image = "${builtins.toString inputs.wallpapers}/${config.hostSpec.wallpaper}";
        targets = {
          nixvim.enable = false;
          alacritty.enable = true;
          helix.enable = true;
          kde.enable = true;
          starship.enable = false;
          swaylock.enable = true;
        };
      };
      # The cursor on plasma behaves a bit wierd without this
      gtk.cursorTheme = {
        inherit (config.home-manager.users.osmo.stylix.cursor) name package;
        size = lib.mkForce cursor-size;
      };
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        size = lib.mkForce cursor-size;
      };
    };
  environment.variables.XCURSOR_SIZE = "24";
  #xdg.icons.fallbackCursorThemes = [ "capitaine-cursors" ];
}
