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
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "\"" = "\"";
            "`" = "`";
            "<" = ">";
          };
          # lsp = {
          #   enable = true;
          #   display-color-swatches = true;
          # };
        };
      };
      languages = {
        language-server = {
          "uwu_colors" = {
            command = "${lib.getExe pkgs.stable.uwu-colors}";
          };
          "rust-analyzer" = {
            cargo.features = "all";
            check.command = "cargo clippy";
          };
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
              "nil"
              "nixd"
              "uwu_colors"
            ];
          }
          {
            name = "javascript";
            indent = {
              tab-width = 4;
              unit = "    ";
            };
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "typescript"
              ];
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
            language-servers = [ "jdtls" ];
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
            roots = [
              "Cargo.toml"
              "Cargo.lock"
            ];
            language-servers = [ "rust-analyzer" ];
            formatter = {
              command = "rustfmt";
              args = [
                "--edition"
                "2024"
              ];
            };
          }
          {
            name = "css";
            scope = "source.css";
            file-types = [ "css" ];
            auto-format = true;
            indent = {
              tab-width = 4;
              unit = "    ";
            };
            language-servers = [ "vscode-css-language-server" ];
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "html"
              ];
            };
          }
          {
            name = "html";
            scope = "source.html";
            file-types = [ "html" ];
            auto-format = true;
            indent = {
              tab-width = 4;
              unit = "    ";
            };
            language-servers = [
              "vscode-html-language-server"
              "superhtml"
            ];
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "html"
              ];
            };
          }
        ];
        extraPackages =
          with pkgs.stable;
          [
            # Language servers
            marksman # Markdown
            nil # Nix
            nixd # -//-
            jdt-language-server # Javascript
            typescript-language-server # Typescript
            vscode-langservers-extracted # Multiple languages
            superhtml # Html
            # rust-analyzer # Rust

            # Misc
            nodePackages.prettier
            lldb # Rust debugger
            uwu-colors # Adds color swatches to languages who's language servers don't support it
            pkg-config
            openssl
          ]
          ++ [ pkgs.unstable.rust-analyzer ];
      };
    };
    # Needs to be in user path????
    home.packages =
      with pkgs.stable;
      [
        # lldb
        # Language servers
        marksman # Markdown
        nil # Nix
        nixd # -//-
        jdt-language-server # Javascript
        typescript-language-server # Typescript
        vscode-langservers-extracted # Multiple languages
        superhtml # Html
        # rust-analyzer # Rust

        # Misc
        nodePackages.prettier
        lldb # Rust debugger
        uwu-colors # Adds color swatches to languages who's language servers don't support it
        pkg-config
        openssl
      ]
      ++ [ pkgs.unstable.rust-analyzer ];
    home.sessionVariables = {
      OPENSSL_DIR = "${pkgs.stable.openssl.dev}";
      PKG_CONFIG_PATH = "${pkgs.stable.openssl.dev}/lib/pkgconfig";
      OPENSSL_INCLUDE_DIR = "${pkgs.stable.openssl.dev}/include";
      OPENSSL_LIB_DIR = "${pkgs.stable.openssl.dev}/lib";
      PKG_CONFIG_ALLOW_SYSTEM_CFLAGS = "1";
      OPENSSL_STATIC = "1";
    };
  };
}
