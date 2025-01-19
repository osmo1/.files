{ config, lib, ... }:
{
  system.activationScripts.gtkFix.text = ''
    #!/bin/bash
    rm -rf ~/.gtkrc-2.0*
  '';
  home-manager.users.osmo =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.stylix.homeManagerModules.stylix ];
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = {
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
        };
        fonts = {
          monospace = {
            name = "FiraCode Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
          };
          sansSerif = {
            name = "Hack Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
          };
          serif = {
            name = "DejaVu Sans Mono";
            package = pkgs.nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
          };
          sizes = {
            applications = 12;
            desktop = 10;
            popups = 10;
            terminal = 14;
          };
        };
        cursor = {
          name = "capitaine-cursors";
          package = pkgs.capitaine-cursors;
          size = 24;
        };
        opacity = {
          desktop = 1;
          applications = 0.9;
          popups = 0.8;
          terminal = 0.9;
        };
        polarity = "dark";
        image = "${builtins.toString inputs.wallpapers}/stolen/plasma2k.png";
        targets = {
          nixvim.enable = false;
          alacritty.enable = true;
        };
      };
      gtk.cursorTheme = {
        inherit (config.home-manager.users.osmo.stylix.cursor) name package; 
        size = lib.mkForce 24;
      };
      home.pointerCursor = {
          gtk.enable = true; 
            x11.enable = true;
        size = lib.mkForce 24;
      };
    };
    environment.variables.XCURSOR_SIZE = "24";
#xdg.icons.fallbackCursorThemes = [ "capitaine-cursors" ];
}
