{ pkgs, ... }:
{
  fonts.packages = with pkgs.stable; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Hack"
        "FiraMono"
      ];
    })
    # "ComicShans" does not exist?
  ];
}
