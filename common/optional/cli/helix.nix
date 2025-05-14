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
            statusline = {
              left = [
                "read-only-indicator"
                "mode"
                "file-name"
                "file-modification-indicator"
              ];
              center = [ ];
              right = [
                "position"
                "total-line-numbers"
              ];
            };
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
          {
            name = "javascript";
            indent = {
              tab-width = 4;
              unit = "    ";
            };
          }
          {
            name = "java";
            scope = "source.java";
            file-types = [ "java" ];
            auto-format = true;
            indent = {
              tab-width = 4;
              unit = "    ";
            };
            language-servers = [ "${pkgs.jdt-language-server}/bin/jdtls" ];
          }
          {
            name = "rust";
            scope = "source.rust";
            file-types = [ "rs" ];
            auto-format = true;
            indent = {
              tab-width = 4;
              unit = "    ";
            };
            language-servers = [ "rust-analyzer" ];
            formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
          }
        ];
        extraPackages = with pkgs; [
          marksman
          nil
          jdt-language-server
          typescript-language-server
          rust-analyzer
          lldb
          rustfmt
        ];
      };
    };
}
