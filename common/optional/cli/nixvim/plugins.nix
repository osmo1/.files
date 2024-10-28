{
programs.nixvim = {
plugins.lsp = {
          enable = true;
          servers = {
            # C/C++
            clangd.enable = true;

            # Rust
            rust-analyzer.enable = true;
            rust-analyzer.installRustc = false;
            rust-analyzer.installCargo = false;

            # Nix
            nixd.enable = true;

            # HTML
            html.enable = true;

            # CSS and Tailwind
            cssls.enable = true;
            tailwindcss.enable = true;

            # Javascript and Typescript
            eslint.enable = true;
            tsserver.enable = true;
          };
        };

        plugins.cmp = {
          enable = true;
          autoEnableSources = true;
          /*
            sources = [
            		    {name = "nvim_lsp";}
            		    {name = "path";}
            		    {name = "buffer";}
            		    {name = "luasnip";}
            		];
          */

          /*
            mapping = {
            		  "<C-Space>" = "cmp.mapping.complete()";
            		  "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            		  "<C-e>" = "cmp.mapping.close()";
            		  "<C-f>" = "cmp.mapping.scroll_docs(4)";
            		  "<CR>" = "cmp.mapping.confirm({ select = true })";
            		  "<S-Tab>" = {
            		    action = "cmp.mapping.select_prev_item()";
            		    modes = [
            		      "i"
            		      "s"
            		    ];
            		  };
            		  "<Tab>" = {
            		    action = "cmp.mapping.select_next_item()";
            		    modes = [
            		      "i"
            		      "s"
            		    ];
            		  };
            		};
          */
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
          comment-nvim.enable = true;
          lsp-format.enable = true;
          chadtree.enable = true;

          lualine = {
            enable = true;
            sectionSeparators = {
              right = "";
              left = "";
            };
            alwaysDivideMiddle = false;
            sections = {
              lualine_a = [
                {
                  name = "mode";
                  color = {
                    fg = "#1b1d2b";
                    bg = "#ff757f";
                  };
                  separator = {
                    right = "";
                  };
                }
                {
                  name = "location";
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
                  name = "branch";
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
                  name = "diff";
                  color = {
                    bg = "#86e1fc";
                    fg = "#1b1d2b";
                  };
                  separator = {
                    right = "";
                  };
                }
                {
                  name = "diagnostics";
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
                  name = "filename";
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
          /*lualine = {
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
          };*/
          telescope.enable = true;
        };
        };
}
