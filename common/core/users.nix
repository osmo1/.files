{
  inputs,
  config,
  ...
}:
{
  imports = [ ../../.secrets/password.nix ];

  users = {
    mutableUsers = false;
    users.osmo = {
      isNormalUser = true;
      uid = 1000;
      # FIXME: Impermanence trickery
      #initialPassword = "osmo";
      # Sops (user secrets) does not want to work with impermanence so im (not) using git-agecrypt
      #hashedPasswordFile = "${secretsPath}/password";
      #hashedPasswordFile = config.sops.secrets.password.path;
      # TODO: Do i need this many groups?
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "input"
        "seat"
        "libvirtd"
        "disk"
      ];
      linger = false;
    };
  };
  users.groups.users.gid = 100;
  # FIXME: Impermanence trickery, no idea if this safe but the fucking passwords don't want to work
  #     environment.persistence."/persist" = {
  #         directories = [ "/run/secrets-for-users"  ];
  #         files = [ "/run/secrets-for-users.d/age-keys.txt" ];
  #     };
  #   systemd.tmpfiles.rules = [
  #       "d /persist/run/secrets-for-users 0777 root root -"
  #   ];
}
