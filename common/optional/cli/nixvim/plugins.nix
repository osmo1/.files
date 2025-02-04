{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        # C/C++
        clangd.enable = true;

        # Rust
        rust_analyzer.enable = true;
        rust_analyzer.installRustc = false;
        rust_analyzer.installCargo = false;

        # Nix
        nixd.enable = true;

        # HTML
        html.enable = true;

        # CSS and Tailwind
        cssls.enable = true;
        tailwindcss.enable = true;

        # Javascript and Typescript
        eslint.enable = true;
        ts_ls.enable = true;
      };
    };

    plugins = {
      dashboard.enable = true;
      which-key.enable = true;
      nvim-colorizer.enable = true;
      treesitter.enable = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
      indent-blankline.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      lsp-format.enable = true;
      chadtree.enable = true;
      web-devicons.enable = true;

      lualine = {
        enable = true;
        settings = {
            options = {
                alwaysDivideMiddle = false;
                sectionSeparators = {
                  right = "";
                  left = "";
                };
            };
        sections = {
          lualine_a = [
            {
              __unkeyed = "mode";
              color = {
                fg = "#1b1d2b";
                bg = "#ff757f";
              };
              separator = {
                right = "";
              };
            }
            {
              __unkeyed = "location";
              color = {
                fg = "#1b1d2b";
                bg = "#ffc777";
              };
              separator = {
                right = "";
              };
            }
          ];
          lualine_b = [
            {
              __unkeyed = "branch";
              icon = "";
              color = {
                fg = "#1b1d2b";
                bg = "#c099ff";
              };
              separator = {
                right = "";
              };
            }
            {
              __unkeyed = "diff";
              color = {
                bg = "#86e1fc";
                fg = "#1b1d2b";
              };
              separator = {
                right = "";
              };
            }
            {
              __unkeyed = "diagnostics";
              color = {
                bg = "#c3e88d";
              };
              separator = {
                right = "";
              };
            }
          ];
          lualine_c = [
            {
              __unkeyed = "filename";
              color = {
                fg = "#b4c0ff";
                bg = "none";
              };
            }
          ];
          lualine_x = [ "null" ];
          lualine_y = [ "null" ];
          lualine_z = [ "null" ];
        };
        };
      };
      /*
        lualine = {
          enable = true;
          sectionSeparators = {
            left = "";
            right = "";
          };
          alwaysDivideMiddle = false;
          sections = {
            lualine_a = [
              {
                name = "mode";
                color = {
                  fg = "#1f1f28";
                  bg = "#7aa89f";
                };
                separator = {
                  right = "";
                };
              }
              {
                name = "location";
                color = {
                  fg = "#1f1f28";
                  bg = "#7e9cd8";
                };
                separator = {
                  right = "";
                };
              }
            ];
            lualine_b = [
              {
                name = "branch";
                icon = "";
                color = {
                  fg = "#1f1f28";
                  bg = "#7fb4ca";
                };
                separator = {
                  right = "";
                };
              }
              {
                name = "diff";
                color = {
                  bg = "#1f1f28";
                };
                separator = {
                  right = "";
                };
              }
              {
                name = "diagnostics";
                color = {
                  bg = "#1f1f28";
                };
                separator = {
                  right = "";
                };
              }
            ];
            lualine_c = [
              {
                name = "filename";
                color = {
                  fg = "#dcd7ba";
                  bg = "none";
                };
              }
            ];
            lualine_x = [ "null" ];
            lualine_y = [ "null" ];
            lualine_z = [ "null" ];
          };
        };
      */
      telescope.enable = true;
    };
  };
}
