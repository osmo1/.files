{ pkgs, configLib, ... }:
{
  imports = (configLib.scanPaths ./.);
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
    ])

    ++

      (with pkgs.unstable; [
        nh
        fzf
      ]);
}
