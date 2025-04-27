{ pkgs, ... }:
{
  environment.systemPackages =
    (with pkgs.stable; [
      neovim
      fastfetch
      git
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
      age-plugin-yubikey
      file
    ])

    ++

      (with pkgs.unstable; [
        nh
        fzf
      ]);
  services.fwupd.enable = true;
}
