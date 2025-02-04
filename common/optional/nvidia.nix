{ config, ... }:
{
  # Enable OpenGL
  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "565.77";
      sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
      sha256_aarch64 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
      openSha256 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
      settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
      persistencedSha256 = "sha256-xctt4TPRlOJ685S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
    };
  };
  boot.kernelParams = [ "module_blacklist=amdgpu" ];
}
