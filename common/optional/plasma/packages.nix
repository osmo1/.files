{ pkgs, ... }:
{
  users.users.osmo.packages =
    with pkgs;
    [
      # Tools
      libsForQt5.qt5ct
    ]
    ++ (with kdePackages; [
      okular
      kate
      plasma-systemmonitor
      gwenview
      spectacle
      filelight
      kcalc
      yakuake
      kolourpaint
      ksystemlog
      isoimagewriter
      elisa
      konversation
      akregator
      kweather
      korganizer
      kontact
      konqueror
      kalarm
      #neochat
      plasmatube
      tokodon
    ]);
}
