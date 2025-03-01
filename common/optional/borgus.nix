{ pkgs, ... }:
{
  users = {
    users.borgus = {
      isNormalUser = false;
      isSystemUser = true;
      group = "users";
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILuY9A1IS3Xz7GqiN32Cy8vQC1UWR6onYsV2Suy17XKs osmo@serveri"
      ];
    };
  };
}
