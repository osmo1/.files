# This module supports multiple YubiKey 4 and/or 5 devices as well as a single Yubico Security Key device. The limitation to a single Security Key is because they do not have serial numbers and therefore the scripts in this module cannot uniquely identify them. See options.yubikey.identifies.description below for information on how to add a 'mock' serial number for a single Security key. Additional context is available in Issue 14 https://github.com/EmergentMind/nix-config/issues/14

{
  config,
  pkgs,
  lib,
  ...
}:
let
  homeDirectory = "/home/osmo";
  yubikey-up =
    let
      yubikeyIds = lib.concatStringsSep " " (
        lib.mapAttrsToList (name: id: "[${name}]=\"${builtins.toString id}\"") { yubi1 = "30649273"; }
      );
    in
    pkgs.writeShellApplication {
      name = "yubikey-up";
      runtimeInputs = builtins.attrValues { inherit (pkgs) gawk yubikey-manager; };
      text = ''
        #!/usr/bin/env bash
        set -euo pipefail

        serial=$(ykman list | awk '{print $NF}')
        # If it got unplugged before we ran, just don't bother
        if [ -z "$serial" ]; then
          # FIXME:(yubikey) Warn probably
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
          echo WARNING: Unidentified yubikey with serial "$serial" . Won\'t link an SSH key.
          exit 0
        fi

        echo "Creating links to ${homeDirectory}/id_$key_name"
        ln -sf "${homeDirectory}/.ssh/id_$key_name" ${homeDirectory}/.ssh/id_yubikey
        ln -sf "${homeDirectory}/.ssh/id_$key_name.pub" ${homeDirectory}/.ssh/id_yubikey.pub
      '';
    };
  yubikey-down = pkgs.writeShellApplication {
    name = "yubikey-down";
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      rm ${homeDirectory}/.ssh/id_yubikey
      rm ${homeDirectory}/.ssh/id_yubikey.pub
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
#yubikey-up
#yubikey-down
    ];


    # FIXME(yubikey): Not sure if we need the wheel one. Also my idProduct group is 0407
    # Yubikey 4/5 U2F+CCID
    # SUBSYSTEM == "usb", ATTR{idVendor}=="1050", ENV{ID_SECURITY_TOKEN}="1", GROUP="wheel"
    # We already have a yubikey rule that sets the ENV variable

    # FIXME(yubikey): This is linux only
    services.udev.extraRules = ''
      ##
      # Yubikey 4
      ##

      # Lock the device if you remove the yubikey (use udevadm monitor -p to debug)
      # #ENV{ID_MODEL_ID}=="0407", # This doesn't match all the newer keys
      # FIXME:(yubikey) We only want this to happen if we're undocked, so we need to see how that works. We probably need to run a
      # script that does smarter checks
      # ACTION=="remove",\
      #  ENV{ID_BUS}=="usb",\
      #  ENV{ID_VENDOR_ID}=="1050",\
      #  ENV{ID_VENDOR}=="Yubico",\
      #  RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

      ##
      # Yubikey 5 BIO
      #
      # NOTE: The remove event for the bio doesn't include the ID_VENDOR_ID for some reason, but we can use the
      # hid name instead. Some HID_NAME might be "Yubico YubiKey OTP+FIDO+CCID" or "Yubico YubiKey FIDO", etc so just
      # match on "Yubico YubiKey"
      ##

      # SUBSYSTEM=="hid",\
      #  ACTION=="remove",\
      #  ENV{HID_NAME}=="Yubico YubiKey FIDO",\
      #  RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"

      # FIXME:(yubikey) Change this so it only wakes up the screen to the login screen, xset cmd doesn't work
      # SUBSYSTEM=="hid",\
      #  ACTION=="add",\
      #  ENV{HID_NAME}=="Yubico YubiKey FIDO",\
      #  RUN+="${pkgs.systemd}/bin/loginctl activate 1"
      #  #RUN+="${lib.getBin pkgs.xorg.xset}/bin/xset dpms force on"
    '';

    # Yubikey required services and config. See Dr. Duh NixOS config for
    # reference
    services.pcscd.enable = true; # smartcard service
    services.udev.packages = [ pkgs.yubikey-personalization ];

    # FIXME(yubikey): Check if this exists on darwin
    services.yubikey-agent.enable = true;

    # yubikey login / sudo
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
        # Attempt to auto-unlock gnome-keyring using u2f
        # NOTE: vscode uses gnome-keyring even if we aren't using gnome, which is why it's still here
        # This doesn't work
        #gnome-keyring = {
        #  text = ''
        #    session    include                     login
        #    session optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
        #  '';
        #};
      };
    };
}
