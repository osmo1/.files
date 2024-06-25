{ pkgs, pkgs-unstable, ... }:
{
    environment.systemPackages = 
        (with pkgs; [
            neovim 
            git
            tmux
            zip
    	    unzip
        ])

        ++

        (with pkgs-unstable; [
            nh
        ]);
}
