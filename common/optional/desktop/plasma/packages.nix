{ pkgs, inputs, ... }:
{
  # TODO: I had planned alphabethical ordering and categories but was too lazy
  users.users.osmo.packages =
    with pkgs;
    [
      haruna
      libsForQt5.qt5ct
      xorg.xkbutils
      inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
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
      kalarm
      #neochat
      plasmatube
      tokodon
      plasma-pa
      krfb
      kwallet-pam
      plasma-vault
    ]);
}
