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
	    lazygit
	    tpm2-tools
	    tpm2-tss
        ])

        ++

        (with pkgs-unstable; [
            nh
	    fzf
        ]);
}
