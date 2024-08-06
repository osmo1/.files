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
        ])

        ++

        (with pkgs-unstable; [
            nh
	    fzf
        ]);
}
