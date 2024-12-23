{ config, ... }:
{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "550.135";
      sha256_64bit = "sha256-ESBH9WRABWkOdiFBpVtCIZXKa5DvQCSke61MnoGHiKk=";
      sha256_aarch64 = "sha256-9hyRiGB+m2hL3c9M3A/Pon+Xl6E788MZ50WrrAGUVuY=";
      openSha256 = "sha256-9hyRiGB+m2hL3c9MDA/Pun+Xl6E788MZ50WrrAGUVuY=";
      settingsSha256 = "sha256-4B61Q4CxDqz/BwmDx6EOtuXV/MNJbaZX+hj/Szo1z1Q=";
      persistencedSha256 = "sha256-xctt5TPRlOJ685S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
    };
  };
  boot.kernelParams = [ "module_blacklist=amdgpu" ];
}
