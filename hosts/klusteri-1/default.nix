{
  config,
  lib,
  configLib,
  pkgs,
  nixvim,
  inputs,
  nur,
  ...
}:

{
    imports = (configLib.scanPaths ./.)
    ++ [
    	../../common/core
	      ../../common/optional/cli
#../../common/optional/impermanence.nix
	      ../../common/optional/podman.nix
#../../common/optional/vpn.nix
	      ../../common/optional/tpm.nix
	      ../../common/optional/ssh.nix
            ../../common/optional/nfs-mount.nix
          ../../common/optional/systemd-boot.nix
	      #../../common/optional/xfce
	      #../../common/optional/sddm.nix
	      #../../common/optional/proton.nix
	      #../../common/optional/sddm.nix
	#../../common/optional/dwl
      #../../common/optional/samba.nix
    ];

  system.stateVersion = "24.05";

  networking.hostName = "klusteri-1";

    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowPing = true;
    hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-sdk
            intel-media-driver # LIBVA_DRIVER_NAME=iHD
            libvdpau-va-gl
            intel-ocl
        ];
      };
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    boot.kernelParams = [
    "i915.enable_guc=2"
  ];
  environment.systemPackages = with pkgs.stable; [ bcache-tools ];
}
