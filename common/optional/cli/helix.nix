{
  home-manager.users.osmo =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        settings = {
          editor = {
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
            line-number = "relative";
          };
        };
        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
        ];
        extraPackages = with pkgs; [
          marksman
          nil
        ];
      };
    };
}
