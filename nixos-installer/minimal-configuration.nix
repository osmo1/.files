{ config, lib, pkgs, unstable-pkgs, configLib, configVars, inputs, ... }:
let
  secretsPath = builtins.toString inputs.secrets;
in
{
  imports = [ 
    (configLib.relativeToRoot "common/core/users.nix")
  ];


  fileSystems."/boot".options = [ "umask=0077" ]; # Removes permissions and security warnings.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    # we use Git for version control, so we don't need to keep too many generations.
    configurationLimit = lib.mkDefault 3;
    # pick the highest resolution for systemd-boot's console.
    consoleMode = lib.mkDefault "max";
  };
  boot.initrd.systemd.enable = true;

  networking = {
    # configures the network interface(include wireless) via `nmcli` & `nmtui`
    networkmanager.enable = true;
  };
  nix.trustedUsers = [ "root" "osmo" "@wheel" ];
  services = {
    qemuGuest.enable = true;
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings.PermitRootLogin = "yes";
      # Fix LPE vulnerability with sudo use SSH_AUTH_SOCK: https://github.com/NixOS/nixpkgs/issues/31611
      # this mitigates the security issue caused by enabling u2fAuth in pam
      #authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    };
  };

  # allow sudo over ssh with yubikey
  # this potentially causes a security issue that we mitigated above
  security.pam = {
    sshAgentAuth.enable = true;
    /*services.sudo = {
      u2fAuth = true;
      sshAgentAuth = true;
    };*/
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) wget curl rsync neovim git just git-agecrypt sops tpm2-tools tpm2-tss;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };
	sops = {
		defaultSopsFile = "${secretsPath}/secrets.yaml";
		validateSopsFiles = false;
		age = {
			sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			keyFile = "/var/lib/sops-nix/key.txt";
			generateKey = true;
		};
		secrets = {
			test = {};
		};
	};
    users.users.root.initialPassword = "osmo";

  sops.secrets."nixos/${config.networking.hostName}/ssh/public" = {};
  system.activationScripts."${configVars.username}-authorizedKeys".text = ''
    mkdir -p "/etc/ssh/authorized_keys.d;
    cp "${config.sops.secrets."nixos/${config.networking.hostName}/ssh/public".path}" "/etc/ssh/authorized_keys.d/${configVars.username}";
    chmod +r "/etc/ssh/authorized_keys.d/${configVars.username};
  '';
  sops.secrets = {
    "nixos/${config.networking.hostName}/git/private" = {
      path = "/home/${configVars.username}/.ssh/git";
      owner = "osmo";
      group = "users";
      mode = "600";
    };
  };
  system.stateVersion = "24.05";
}
