{ pkgs, ... }:
{
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "osmo";
  };
  security.pam.services = {
    login.kwallet = {
      enable = true;
      #package = pkgs.kdePackages.kwallet-pam;
    };
    kde = {
      kwallet = {
        enable = true;
        #package = pkgs.kdePackages.kwallet-pam;
      };
    };
  };
}
