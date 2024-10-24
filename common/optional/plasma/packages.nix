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
      kompare
      isoimagewriter
      elisa
      konversation
      akgregator
      kmix
      kweather
      korganizer
      kontact
      konqueror
      kalarm
      neochat
      plasmatube
      tokodon
    ]);
}
