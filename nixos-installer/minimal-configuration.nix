{
  pkgs,
  configLib,
  lib,
  ...
}:
{
  imports = [
    (configLib.relativeToRoot "common/core/users.nix")
  ];

  fileSystems."/boot".options = [ "umask=0077" ]; # Removes permissions and security warnings.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  networking = {
    networkmanager.enable = true;
  };
  nix.trustedUsers = [
    "root"
    "osmo"
  ];
  services = {
    qemuGuest.enable = true;
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings.PermitRootLogin = "yes";
      # Fix LPE vulnerability with sudo use SSH_AUTH_SOCK: https://github.com/NixOS/nixpkgs/issues/31611
      # this mitigates the security issue caused by enabling u2fAuth in pam
      authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    };
  };
  programs.ssh.startAgent = true;
  # allow sudo over ssh with yubikey
  # this potentially causes a security issue that we mitigated above
  security.pam = {
    sshAgentAuth.enable = true;
      services.sudo = {
        u2fAuth = true;
        sshAgentAuth = true;
      };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      wget
      curl
      rsync
      neovim
      git
      just
      git-agecrypt
      tpm2-tools
      tpm2-tss
      ;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };
  users.users.root.initialPassword = "osmo";
  system.stateVersion = "24.05";
}
