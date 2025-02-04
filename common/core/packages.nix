{ pkgs, configLib, ... }:
{
  environment.systemPackages =
    (with pkgs.stable; [
      neovim
      fastfetch
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
      dust
      borgbackup
    ])

    ++

      (with pkgs.unstable; [
        nh
        fzf
      ]);
  programs.thefuck.enable = true;
  services.fwupd.enable = true;
}
