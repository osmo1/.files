{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/podman.nix
    ../../common/optional/tpm.nix
    ../../common/optional/ssh.nix
    ../../common/optional/nfs-mount.nix
    ../../common/optional/systemd-boot.nix
    ../../common/optional/beszel.nix
  ];

  hostSpec = {
    hostName = "klusteri-1";
    isServer = true;
  };

  restic = {
    enable = true;
    remote = true;
    extraExcludes = [
      "/home/osmo/tmp"
    ];
  };

  # This should be moved to a module for the klusteris
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      # intel-media-sdk # Insecure, still unsure if replacement needed
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      libvdpau-va-gl
      intel-ocl
      intel-vaapi-driver
      libva-vdpau-driver
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  environment.sessionVariables = {
    #LIBVA_DRIVER_NAME = "iHD";
    LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.dbus ];
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  environment.systemPackages = with pkgs.stable; [ bcache-tools ];
}
