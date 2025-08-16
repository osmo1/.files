{ pkgs, ... }:
{
  environment.systemPackages =
    (with pkgs.stable; [
      (lib.hiPrio uutils-coreutils-noprefix)
      helix
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
      dig
    ])

    ++

      (with pkgs.unstable; [
        nh
        nix-output-monitor
        fzf
      ]);
  services.fwupd.enable = true;
}
