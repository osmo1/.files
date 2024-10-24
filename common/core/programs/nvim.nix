{ inputs, pkgs, ... }: {
  home-manager.users.osmo = { inputs, pkgs, ... }: {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];
    programs.nixvim = {
	    enable = true;
	    extraPlugins = with pkgs.vimPlugins; [
		telescope-file-browser-nvim
		plenary-nvim
	    ];
	    
	    options = {
		number = true;
		relativenumber = true;

		shiftwidth = 4;
	    };

	    colorschemes.kanagawa = {
		enable = true;
		theme = "wave";
		transparent = true;
	    };
		
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
		/*sources = [
		    {name = "nvim_lsp";}
		    {name = "path";}
		    {name = "buffer";}
		    {name = "luasnip";}
		];*/

		/*mapping = {
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
		};*/
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
			left = "";
			right = "";
		    };
		    alwaysDivideMiddle = false;
		    sections = {
			lualine_a = [{
				name = "mode";
				color = {
				    fg = "#1f1f28";
				    bg = "#7aa89f";
				};
				separator = {
				    right = "";
				};
			    }{
				name = "location";
				color = {
				    fg = "#1f1f28";
				    bg = "#7e9cd8";
				};
				separator = {
				    right = "";
				};
			}];
			lualine_b = [{
				name = "branch";
				icon = "";
				color = {
				    fg = "#1f1f28";
				    bg = "#7fb4ca";
				};
				separator = {
				    right = "";
				};
			    }{
				name = "diff";
				color = {bg = "#1f1f28";};
				separator = {
				    right = "";
				};
			    }{
				name = "diagnostics";
				color = {bg = "#1f1f28";};
				separator = {
				    right = "";
				};
			}];
			lualine_c = [{
				name = "filename";
				color = {
				    fg = "#dcd7ba";
				    bg = "none";
				    };
			}];
			lualine_x = ["null"];
			lualine_y = ["null"];
			lualine_z = ["null"];
		    };
		};
		telescope.enable = true;
	    };
	  };
	  };
}
