{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs.stable; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      font-awesome
      source-han-sans
      source-han-serif
      cantarell-fonts
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.fira-mono
      nerd-fonts.comic-shanns-mono
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      cache32Bit = true;
      allowBitmaps = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Source Han Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "Source Han Sans"
        ];
      };
    };
  };
}
