{ pkgs, inputs, ... }:
{
  # ...

  # See https://github.com/starcitizen-lug/knowledge-base/wiki/Manual-Installation#prerequisites
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  zramSwap = {
    enable = true;
    memoryMax = 32 * 1024 * 1024 * 1024;  # 16 GB ZRAM
  };

  # The following line was used in my setup, but I'm unsure if it is still needed
  # hardware.pulseaudio.extraConfig = "load-module module-combine-sink";

  users.users.osmo.packages = with pkgs.stable; [
      # tricks override to fix audio
      # see https://github.com/fufexan/nix-gaming/issues/165#issuecomment-2002038453
      (inputs.nix-gaming.packages.${pkgs.unstable.system}.star-citizen.override {
        tricks = [ "arial" "vcrun2019" "win10" "sound=alsa" ];
  })];
}

