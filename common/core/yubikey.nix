{
  pkgs,
  lib,
  ...
}:
let
  homeDirectory = "/home/osmo";
  yubikey-up =
    let
      yubikeyIds = lib.concatStringsSep " " (
        lib.mapAttrsToList (name: id: "[${name}]=\"${builtins.toString id}\"") { yubi-0 = "30649273"; }
      );
    in
    pkgs.writeShellApplication {
      name = "yubikey-up";
      runtimeInputs = builtins.attrValues {
        inherit (pkgs)
          gawk
          yubikey-manager
          age
          age-plugin-yubikey
          ;
      };
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        serial=$(ykman list | awk '{print $NF}')
        # If it got unplugged before we ran, just don't bother
        if [ -z "$serial" ]; then
          # FIXME(yubikey): Warn probably
          exit 0
        fi

        declare -A serials=(${yubikeyIds})

        key_name=""
        for key in "''${!serials[@]}"; do
          if [[ $serial == "''${serials[$key]}" ]]; then
            key_name="$key"
          fi
        done

        if [ -z "$key_name" ]; then
          echo "WARNING: Unidentified yubikey with serial $serial. Won't link an age key."
          exit 0
        fi

        age_dir="${homeDirectory}/.config/age"
        mkdir -p "$age_dir"

        echo "Extracting age key to $age_dir/age_$key_name"
        age-plugin-yubikey --identity --slot 1 > "$age_dir/$key_name-age"
      '';
    };

  yubikey-down = pkgs.writeShellApplication {
    name = "yubikey-down";
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      rm -f ${homeDirectory}/.config/age/*
    '';
  };
in
{

  environment.systemPackages = lib.flatten [
    (builtins.attrValues {
      inherit (pkgs)
        yubioath-flutter # gui-based authenticator tool. yubioath-desktop on older nixpkg channels
        yubikey-manager # cli-based authenticator tool. accessed via `ykman`

        pam_u2f # for yubikey with sudo
        ;
    })
    yubikey-up
    yubikey-down
  ];

  # FIXME(yubikey): Not sure if we need the wheel one. Also my idProduct group is 0407
  # Yubikey 4/5 U2F+CCID
  # SUBSYSTEM == "usb", ATTR{idVendor}=="1050", ENV{ID_SECURITY_TOKEN}="1", GROUP="wheel"
  # We already have a yubikey rule that sets the ENV variable

  services.udev.extraRules = ''
    # Link/unlink ssh key on yubikey add/remove
    SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="1050", RUN+="${lib.getBin yubikey-up}/bin/yubikey-up"
    # NOTE: Yubikey 4 has a ID_VENDOR_ID on remove, but not Yubikey 5 BIO, whereas both have a HID_NAME.
    # Yubikey 5 HID_NAME uses "YubiKey" whereas Yubikey 4 uses "Yubikey", so matching on "Yubi" works for both
    SUBSYSTEM=="hid", ACTION=="remove", ENV{HID_NAME}=="Yubico Yubi*", RUN+="${lib.getBin yubikey-down}/bin/yubikey-down"
  '';

  # Yubikey required services and config. See Dr. Duh NixOS config for reference
  services.pcscd.enable = true; # smartcard service
  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.yubikey-agent.enable = true;

  # Yubikey login / sudo
  security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
    sshAgentAuth.enable = true;
    u2f = {
      enable = true;
      settings = {
        cue = true; # Tells user they need to press the button
        authFile = "${homeDirectory}/.config/Yubico/u2f_keys";
      };
    };
    services = {
      login.u2fAuth = true;
      sudo = {
        u2fAuth = true;
        sshAgentAuth = true; # Use SSH_AUTH_SOCK for sudo
      };
    };
  };
}
