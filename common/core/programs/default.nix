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
	    lazygit
	    just
        ])

        ++

        (with pkgs-unstable; [
            nh
	    fzf
        ]);
}
