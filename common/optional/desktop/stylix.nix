{
  home-manager.users.osmo =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.stylix.homeManagerModules.stylix ];
      stylix = {
          enable = true;
          base16Scheme = ''
              base00: "24283b"\n
              base01: "1f2335"\n
              base02: "292e42"\n
              base03: "565f89"\n
              base04: "a9b1d6"\n
              base05: "c0caf5"\n
              base06: "c0caf5"\n
              base07: "c0caf5"\n
              base08: "f7768e"\n
              base09: "ff9e64"\n
              base0A: "e0af68"\n
              base0B: "9ece6a"\n
              base0C: "1abc9c"\n
              base0D: "41a6b5"\n
              base0E: "bb9af7"\n
              base0F: "ff007c"\n
          '';
          cursor = {
            name = "Capitane";
            package = pkgs.stable.capitaine-cursors;
            size = 24;
          };
          opacity = {
              desktop = 1;
              applications = 0.9;
              popups = 0.8;
              terminal = 0.7;
          };
          polarity = "dark";
      };
    };
}
