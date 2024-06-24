{ config, lib, pkgs, pkgs-unstable, nixvim, inputs, nur, ... }:

{
    imports =
    [
        ./hardware-configuration.nix
        #../../modules/nixvim.nix
    ];

    system.stateVersion = "24.05";

    boot = {
    	loader = {
	    systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
	};
	plymouth = {
            enable = true;
            /*theme = "rings";
	    themePackages = with pkgs; [
		(adi1090x-plymouth-themes.override {
		  selected_themes = [ "rings" ];
		})
	    ];*/
	};
	consoleLogLevel = 0;
	initrd.verbose = false;
	kernelPackages = pkgs.linuxPackages_zen;
	kernelParams = [
	    "quiet"
	    "splash"
	    "boot.shell_on_fail"
	    "loglevel=3"
	    "rd.systemd.show_status=false"
	    "rd.udev.log_level=3"
	    "udev.log_priority=3"
	];
	loader.timeout = 0;
    };
    /*boot.initrd.postDeviceCommands = lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/root_vg/root /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +14); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
    '';

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist/system" = {
        hideMounts = true;
        directories = [
            "/etc/nixos"
            "/etc/ssh"
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/samba"
            "/var/lib/docker"
            "/var/lib/systemd/coredump"
            "/var/lib/nixos-containers/"
            # { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
        ];
        files = [
            "/etc/machine-id"
            # { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
        ];
    };*/

    networking.hostName = "lixos";
    time.timeZone = "Europe/Helsinki";

    

    users.users.osmo = {
        isNormalUser = true;
        initialPassword = "osmo";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            kate
        ];
    };

    /*systemd.services.fprintd = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "simple";
    };

    services.fprintd = {
	enable = true;
    	tod = {
    	    enable = true;
    	    driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
                calib-data-file = /home/osmo/misc/calib-data.bin;
            };
        };
    };*/
    
    services.open-fprintd.enable = true;
    services.python-validity.enable = true;

    security.pam.services.sudo.fprintAuth = true;
    /*security.pam.services.sudo.text = ''
	# Account management.
	account required pam_unix.so

	# Authentication management.
	auth sufficient pam_unix.so   likeauth try_first_pass nullok
	auth sufficient ${inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients}/lib/security/pam_fprintd.so
	auth required pam_deny.so

	# Password management.
	password sufficient pam_unix.so nullok sha512

	# Session management.
	session required pam_env.so conffile=/etc/pam/environment readenv=0
	session required pam_unix.so
    '';*/



#    home-manager = {
#	extraSpecialArgs = {inherit inputs;};
#	users = {
#	    "osmo" = import ./home.nix;
#	};
#    };
    
    /*systemd.tmpfiles.rules = [
        "d /persist/home 0777 root root -"
        "d /persist/home/osmo 0770 osmo users -"
    ];*/

    environment.sessionVariables = {
        FLAKE = "/home/osmo/.files";
    };
    environment.systemPackages = 
        (with pkgs; [
            neovim 
            git
            tmux
            wireguard-tools
            zip
	    (librewolf.override { cfg.enablePlasmaBrowserIntegration = true; })
	    anki
	    bitwarden
        ])

        ++

        (with pkgs-unstable; [
            nh
        ]);

 
    security.sudo.extraConfig = ''
	      Defaults lecture = never
    '';

    nix.settings.experimental-features = [ "nix-command" "flakes"];

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
        layout = "fi";
    	variant = "winkeys";
    };
  };

  # Configure console keymap
  console.keyMap = "fi";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

}
