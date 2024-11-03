{ pkgs, ... }: {
    fonts.packages = with pkgs.stable; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" "Hack" ]; })
        # "ComicShans" does not exist?
    ];
}
