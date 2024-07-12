{ config, lib, pkgs, pkgs-unstable, nixvim, inputs, nur, ... }:

{
    imports = (configLib.scanPaths ./.)
    ++ [
    	../../common/core
      ../../common/optional/impermanence.nix
      ../../common/optional/podman.nix
      ../../common/optional/samba.nix
    ];

    system.stateVersion = "24.05";

    networking.hostName = "serveri";

    #TODO: Find a better place for this
    # common/core ?
    boot = {
    	loader = {
	      systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
	    };
    };

    users.users = {
        osmo.openssh.authorizedKeys.keys = ["ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAHJ/M6rFAFiOJjaFdLsltTsNXQGwQQloLbmgPG4K5VcxAqXI5Mztjyobh8L3R1oasO5lnsRGhrc0YvoLeuMga3YpAEtnew1UK+YwmM6otNGZd+2rqpyBWEjR2Cgt71bimT5lXf5xHfxjBcw6UbBvlDEj6tgi3mJusx+6hPcWSC4uj1wOA== osmo@osmo-masiina"];
        monitor.openssh.authorizedKeys.keys = ["ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAGuCGoEj++ljHdu52zkWdZcizDCm+ljQEeuS5JSKhpDzqU3nOSLyNUKHkqJhoy9oUips+Lq4BV98PYDex8yiEFuIQFr9ZNq+0bdXPrwfonHtaqskBNWVqHyo41dD6pRI91z9WKc6Gm80HRUVVOrdbam9cyt+/V9HJALobdVglHF82HkQg== osmo@serveri"];
    };

    #TODO: Find a better place for this
    # common/optional/ssh.nix ?
    services.openssh = {
    	enable = true;
    	settings.PasswordAuthentication = false;
    	settings.KbdInteractiveAuthentication = false;
    	settings.PermitRootLogin = "no";
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowPing = true;
}
