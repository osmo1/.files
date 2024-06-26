{ config, lib, pkgs, pkgs-unstable, nixvim, inputs, nur, ... }:

{
    imports =
    [
        ./hardware-configuration.nix
        ./home.nix
    	../../common/core
	../../common/optional/plasma
	../../common/optional/printing.nix
    ];

    system.stateVersion = "24.05";

    #TODO: Find a better place for this
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

    networking.hostName = "lixos";


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
}
