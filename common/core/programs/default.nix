{ pkgs, pkgs-unstable, ... }:
{
    environment.systemPackages = 
        (with pkgs; [
            neovim 
            git
            tmux
            zip
    	    unzip
	    tree
	    sops
	    git-agecrypt
	    just
        ])

        ++

        (with pkgs-unstable; [
            nh
	    fzf
	    lazygit
        ]);
}
