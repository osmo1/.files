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
        ])

        ++

        (with pkgs-unstable; [
            nh
	    fzf
        ]);
}
