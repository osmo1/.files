{ pkgs, ... }:
{
  fonts.packages = with pkgs.stable; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.fira-mono
    nerd-fonts.comic-shanns-mono
  ];
}
