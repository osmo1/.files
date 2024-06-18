{ config, lib, pkgs, pkgs-unstable, nixvim, inputs, ... }:

{
    imports =
    [
        ./hardware-configuration.nix
        #../../modules/nixvim.nix
    ];

    system.stateVersion = "24.05";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
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

    networking.hostName = "none";
    time.timeZone = "Europe/Helsinki";

    

    users.users.osmo = {
        isNormalUser = true;
        initialPassword = "osmo";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
            kate
        ];
    };




#    home-manager = {
#	extraSpecialArgs = {inherit inputs;};
#	users = {
#	    "osmo" = import ./home.nix;
#	};
#    };
    
    systemd.tmpfiles.rules = [
        "d /persist/home 0777 root root -"
        "d /persist/home/osmo 0770 osmo users -"
    ];

    environment.sessionVariables = {
        FLAKE = "/home/osmo/.siles";
    };
    environment.systemPackages = 
        (with pkgs; [
            neovim 
            git
            tmux
            wireguard-tools
            zip
        ])

        ++

        (with pkgs-unstable; [
            nh
        ]);

 
    security.sudo.extraConfig = ''
	      Defaults lecture = never
    '';

    nix.settings.experimental-features = [ "nix-command" "flakes"];





  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "fi";
    xkbVariant = "winkeys";
  };

  # Configure console keymap
  console.keyMap = "fi";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}
