{ pkgs, lib, ... }:
{
  home-manager.users.osmo = {
    programs.helix = {
      enable = true;
      package = pkgs.unstable.helix; # TODO: Change this after 25.11 (hopefully)
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
          inline-diagnostics = {
            cursor-line = "warning";
            prefix-len = 2;
          };
          lsp = {
            enable = true;
            display-color-swatches = true;
          };
        };
      };
      languages = {
        language-server."uwu_colors" = {
          command = "${lib.getExe pkgs.stable.uwu-colors}";
        };

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.stable.nixfmt-rfc-style}/bin/nixfmt";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            language-servers = [
              "uwu_colors"
            ];
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
            language-servers = [ "${pkgs.stable.jdt-language-server}/bin/jdtls" ];
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
            formatter.command = "${pkgs.stable.rustfmt}/bin/rustfmt";
          }
        ];
        extraPackages = with pkgs.stable; [
          # Language servers
          marksman # Markdown
          nil # Nix
          nixd # -//-
          jdt-language-server # Javascript
          typescript-language-server # Typescript
          rust-analyzer # Rust

          # Misc
          lldb # Rust debugger
          rustfmt # Rust formatter
          uwu-colors # Adds color swatches to languages who's language servers don't support it
        ];
      };
    };
  };
}
