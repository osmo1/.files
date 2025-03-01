{ pkgs, ... }:
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
      restic
    ])

    ++

      (with pkgs.unstable; [
        nh
        fzf
      ]);
  services.fwupd.enable = true;
}
